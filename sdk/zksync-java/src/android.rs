#![cfg(target_os = "android")]
#![allow(non_snake_case)]

use super::{
  private_key_from_seed, private_key_to_pubkey_hash, public_key_from_private, sign_musig,
};
use jni::objects::{JClass, JString};
use jni::sys::{jbyteArray, jstring};
use jni::JNIEnv;
use std::ffi::{CStr, CString};
use std::os::raw::c_char;

#[no_mangle]
pub unsafe extern "system" fn Java_com_numio_zksyncsign_CryptoKt_privateKeyToPublicKeyHash(
  env: JNIEnv,
  _class: JClass,
  input: JString,
) -> jstring {
  // `JNIEnv` cannot be sent across thread boundaries. To be able to use JNI
  // functions in other threads, we must first obtain the `JavaVM` interface
  // which, unlike `JNIEnv` is `Send`.
  // let jvm = env.get_java_vm().unwrap();

  let private_key_str = CString::new(
    CStr::from_ptr(env.get_string(input).unwrap().as_ptr())
      .to_str()
      .expect("Error Unwrapping CStr"),
  )
  .expect("Error converting C string");

  // // Read `input` from java
  // let private_key_str = env
  //   .get_string_utf_chars(input)
  //   .expect("Couldn't retrieve private key");

  // We need to obtain global reference to the `callback` object before sending
  // it to the thread, to prevent it from being collected by the GC.
  // let callback = env.new_global_ref(callback).unwrap();

  // Use channel to prevent the Java program to finish before the thread
  // has chance to start.
  // let (tx, rx) = mpsc::channel();

  // let _ = thread::spawn(move || {
  //   // Signal that the thread has started.
  //   tx.send(()).unwrap();

  // Use the `JavaVM` interface to attach a `JNIEnv` to the current thread.
  // let env = jvm.attach_current_thread().unwrap();

  let output = env
    .new_string(private_key_to_pubkey_hash(private_key_str.to_bytes()))
    .expect("Couldn't create public key hash!");

  output.into_inner()

  //   env
  //     .call_method(&callback, "asyncCallback", "(I)V", &[output.into()])
  //     .unwrap();
  // });
  // rx.recv().unwrap();
}

#[no_mangle]
pub unsafe extern "system" fn Java_com_numio_zksyncsign_CryptoKt_privateKeyFromSeed(
  env: JNIEnv,
  _class: JClass,
  input: JString,
) -> jstring {
  // `JNIEnv` cannot be sent across thread boundaries. To be able to use JNI
  // functions in other threads, we must first obtain the `JavaVM` interface
  // which, unlike `JNIEnv` is `Send`.
  // let jvm = env.get_java_vm().unwrap();

  // Read `input` from java
  let seed_str = CString::from(CStr::from_ptr(env.get_string(input).unwrap().as_ptr()));
  // We need to obtain global reference to the `callback` object before sending
  // it to the thread, to prevent it from being collected by the GC.
  // let callback = env.new_global_ref(callback).unwrap();

  // Use channel to prevent the Java program to finish before the thread
  // has chance to start.
  // let (tx, rx) = mpsc::channel();

  // let _ = thread::spawn(move || {
  // Signal that the thread has started.
  // tx.send(()).unwrap();

  // Use the `JavaVM` interface to attach a `JNIEnv` to the current thread.
  // let env = jvm.attach_current_thread().unwrap();

  let output = env
    .new_string(&private_key_from_seed(&seed_str.to_bytes()))
    .expect("Couldn't create public key hash!");
  output.into_inner()

  // env
  // 	.call_method(&callback, "asyncCallback", "(I)V", &[output.into()])
  // 	.unwrap();
  // });
  // rx.recv().unwrap();
}

#[no_mangle]
pub unsafe extern "system" fn Java_com_numio_zksyncsign_CryptoKt_signTransactionBytes(
  env: JNIEnv,
  _class: JClass,
  private_key: JString,
  txn_bytes: JString,
  // callback: JObject,
) -> jstring {
  // `JNIEnv` cannot be sent across thread boundaries. To be able to use JNI
  // functions in other threads, we must first obtain the `JavaVM` interface
  // which, unlike `JNIEnv` is `Send`.
  // let jvm = env.get_java_vm().unwrap();

  // Read `private_key` & `txn_bytes` from java
  let pkey_str = CString::from(CStr::from_ptr(
    env.get_string(private_key).unwrap().as_ptr(),
  ));

  let txn_str = CString::from(CStr::from_ptr(env.get_string(txn_bytes).unwrap().as_ptr()));
  // We need to obtain global reference to the `callback` object before sending
  // it to the thread, to prevent it from being collected by the GC.
  // let callback = env.new_global_ref(callback).unwrap();

  // Use channel to prevent the Java program to finish before the thread
  // has chance to start.
  // let (tx, rx) = mpsc::channel();

  // let _ = thread::spawn(move || {
  // 	// Signal that the thread has started.
  // 	tx.send(()).unwrap();

  // 	// Use the `JavaVM` interface to attach a `JNIEnv` to the current thread.
  // 	let env = jvm.attach_current_thread().unwrap();

  let tx_signature = env.new_string(sign_musig(&pkey_str.to_bytes(), &txn_str.to_bytes()));

  tx_signature
    .expect("Couldn't create java string!")
    .into_inner()
  // 	env
  // 		.call_method(&callback, "asyncCallback", "(I)V", &[output.into()])
  // 		.unwrap();
  // });
  // rx.recv().unwrap();
}

#[cfg(test)]
mod test {
  #[test]
  fn it_works() {
    println!("It Works");
  }
}
