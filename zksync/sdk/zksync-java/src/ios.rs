use std::ffi::{CStr, CString};
use std::os::raw::c_char;
use crate::sign::{
  private_key_from_seed as other_private_key_from_seed, private_key_to_pubkey, private_key_to_pubkey_hash, sign_musig as other_sign_musig,
};

#[no_mangle]
pub unsafe extern "C" fn public_key_hash_from_private_key(private_key: *const c_char) -> *mut c_char {
  let c_str = CStr::from_ptr(private_key);
  let private_key_str = match c_str.to_str() {
    Ok(s) => s,
    Err(_) => "fuck",
  };

  let result = private_key_to_pubkey_hash(&hex::decode(private_key_str).expect("Couldn't decode string input"));

  CString::new(result)
    .unwrap()
    .into_raw()
}

#[no_mangle]
pub unsafe extern "C" fn private_key_from_seed(seed: *const c_char) -> *mut c_char {
  let seed_c_str = CStr::from_ptr(seed);
  let seed_str = match seed_c_str.to_str() {
    Ok(s) => s,
    Err(_) => "fuck",
  };

  let result = other_private_key_from_seed(
    &hex::decode(seed_str).expect("Couldn't decode hex seed input"),
  );

  CString::new(result)
    .unwrap()
    .into_raw()
}

#[no_mangle]
pub unsafe extern "C" fn public_key_from_private_key(private_key: *const c_char) -> *mut c_char {
  let c_str = CStr::from_ptr(private_key);
  let private_key_str = match c_str.to_str() {
    Ok(s) => s,
    Err(_) => "fuck",
  };

  let result = private_key_to_pubkey(&hex::decode(private_key_str).expect("Couldn't decode string input"));

  CString::new(result)
      .unwrap()
      .into_raw()
}

#[no_mangle]
pub unsafe extern "C" fn sign_musig(private_key: *const c_char, txn_msg: *const c_char) -> *mut c_char {
  let pkey_c_str = CStr::from_ptr(private_key);
  let txn_msg_c_str = CStr::from_ptr(txn_msg);
  let private_key_str = match pkey_c_str.to_str() {
    Ok(s) => s,
    Err(_) => "fuck",
  };

  let txn_msg_str = match txn_msg_c_str.to_str() {
    Ok(s) => s,
    Err(_) => "fuck",
  };

  let result = other_sign_musig(
    &hex::decode(private_key_str).expect("Couldn't decode private_key_str input"),
    &hex::decode(txn_msg_str).expect("Couldn't decode private_key_str input"),
  );

  CString::new(result)
    .unwrap()
    .into_raw()
}

#[no_mangle]
pub unsafe extern "C" fn string_release(s: *mut c_char) {
  if s.is_null() {
    return;
  }
  CString::from_raw(s);
}
