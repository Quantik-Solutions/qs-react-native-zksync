const PACKED_POINT_SIZE: usize = 32;
const PACKED_SIGNATURE_SIZE: usize = 64;

pub use franklin_crypto::bellman::pairing::bn256::{Bn256 as Engine, Fr, FrRepr};
use franklin_crypto::rescue::bn256::Bn256RescueParams;

pub type Fs = <Engine as JubjubEngine>::Fs;

thread_local! {
    pub static JUBJUB_PARAMS: AltJubjubBn256 = AltJubjubBn256::new();
    pub static RESCUE_PARAMS: Bn256RescueParams = Bn256RescueParams::new_checked_2_into_1();
}
use franklin_crypto::{
  alt_babyjubjub::{fs::FsRepr, AltJubjubBn256, FixedGenerators},
  eddsa::{PrivateKey, PublicKey, Seed},
  jubjub::JubjubEngine,
};

use crate::utils::{pub_key_hash, rescue_hash_tx_msg};
// use crypto_lib::public_key_from_private;
use franklin_crypto::bellman::pairing::ff::{PrimeField, PrimeFieldRepr};
use sha2::{Digest, Sha256};
use zksync_types::PubKeyHash;

pub fn private_key_from_seed(seed: &[u8]) -> String {
  if seed.len() < 32 {
    panic!("Seed is too short");
  };

  let sha256_bytes = |input: &[u8]| -> Vec<u8> {
    let mut hasher = Sha256::new();
    hasher.input(input);
    hasher.result().to_vec()
  };

  let mut effective_seed = sha256_bytes(seed);

  loop {
    let raw_priv_key = sha256_bytes(&effective_seed);
    let mut fs_repr = FsRepr::default();
    fs_repr
      .read_be(&raw_priv_key[..])
      .expect("failed to read raw_priv_key");
    if Fs::from_repr(fs_repr).is_ok() {
      return hex::encode(raw_priv_key);
    } else {
      effective_seed = raw_priv_key;
    }
  }
}

pub(crate) fn read_signing_key(private_key: &[u8]) -> PrivateKey<Engine> {
  let mut fs_repr = FsRepr::default();
  fs_repr
    .read_be(private_key)
    .expect("couldn't read private key repr");
  PrivateKey::<Engine>(Fs::from_repr(fs_repr).expect("couldn't read private key from repr"))
}

fn privkey_to_pubkey_internal(private_key: &[u8]) -> PublicKey<Engine> {
  let p_g = FixedGenerators::SpendingKeyGenerator;

  let sk = read_signing_key(private_key);

  JUBJUB_PARAMS.with(|params| PublicKey::from_private(&sk, p_g, params))
}

pub fn private_key_to_pubkey_hash(private_key: &[u8]) -> String {
  private_key.to_owned();
  PubKeyHash::from_bytes(&pub_key_hash(&privkey_to_pubkey_internal(private_key)))
    .unwrap()
    .to_hex()
}

pub fn private_key_to_pubkey(private_key: &[u8]) -> String {
  let mut pubkey_buf = Vec::with_capacity(PACKED_POINT_SIZE);
  let pubkey = privkey_to_pubkey_internal(private_key);

  pubkey
    .write(&mut pubkey_buf)
    .expect("failed to write pubkey to buffer");

  hex::encode(pubkey_buf)
}

/// We use musig Schnorr signature scheme.
/// It is impossible to restore signer for signature, that is why we provide public key of the signer
/// along with signature.
/// [0..32] - packed public key of signer.
/// [32..64] - packed r point of the signature.
/// [64..96] - s poing of the signature.
pub fn sign_musig(private_key: &[u8], msg: &[u8]) -> String {
  private_key.to_owned();
  msg.to_owned();
  let mut packed_full_signature = Vec::with_capacity(PACKED_POINT_SIZE + PACKED_SIGNATURE_SIZE);
  //
  let p_g = FixedGenerators::SpendingKeyGenerator;
  let private_key = read_signing_key(private_key);

  {
    let public_key =
      JUBJUB_PARAMS.with(|params| PublicKey::from_private(&private_key, p_g, params));
    public_key
      .write(&mut packed_full_signature)
      .expect("failed to write pubkey to packed_point");
  };
  //
  let signature = JUBJUB_PARAMS.with(|jubjub_params| {
    RESCUE_PARAMS.with(|rescue_params| {
      let hashed_msg = rescue_hash_tx_msg(msg);
      let seed = Seed::deterministic_seed(&private_key, &hashed_msg);
      private_key.musig_rescue_sign(&hashed_msg, &seed, p_g, rescue_params, jubjub_params)
    })
  });

  signature
    .r
    .write(&mut packed_full_signature)
    .expect("failed to write signature");
  signature
    .s
    .into_repr()
    .write_le(&mut packed_full_signature)
    .expect("failed to write signature repr");

  assert_eq!(
    packed_full_signature.len(),
    PACKED_POINT_SIZE + PACKED_SIGNATURE_SIZE,
    "incorrect signature size when signing"
  );

  hex::encode(&packed_full_signature)
}

// TODO: Finish building out the interface
pub fn pub_key_from_private() {
  // private_key.to_owned();
}
