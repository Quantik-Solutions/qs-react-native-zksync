// #![cfg(target_os = "android")]
#![allow(non_snake_case)]
use crate::sign::{
  private_key_from_seed, private_key_to_pubkey, private_key_to_pubkey_hash, sign_musig,
};
use jni::objects::{JClass, JObject, JString};
use jni::JNIEnv;
use std::sync::mpsc;
use std::thread;

#[no_mangle]
pub extern "system" fn Java_com_numio_ZkSync_publicKeyHashFromPrivateKey(
  env: JNIEnv,
  _class: JClass,
  callback: JObject,
  privateKey: JString,
) {
  // Obtain the `JavaVM` interface
  let jvm = env.get_java_vm().unwrap();

  // Obtain global reference to the `callback` object before sending
  // it to the thread, to prevent it from being collected by the GC.
  let callback = env.new_global_ref(callback).unwrap();
  let private_key = env.new_global_ref(JObject::from(privateKey)).unwrap();

  // Use channel to prevent the Java program to finish before the thread
  // has chance to start.
  let (tx, rx) = mpsc::channel();

  let _ = thread::spawn(move || {
    // Signal that the thread has started.
    tx.send(()).unwrap();

    // Use the `JavaVM` interface to attach a `JNIEnv` to the current thread.
    let env = jvm.attach_current_thread().unwrap();

    // Get the string value from `private_key` after referencing the global pointer ref.
    let private_key_str: String = env
      .get_string(JString::from(private_key.as_obj()))
      .expect("Error converting string")
      .into();

    // Get the main result after calling the inner function `private_key_to_pubkey_hash`
    let output = env
      .new_string(&private_key_to_pubkey_hash(
        &hex::decode(&private_key_str).expect("Couldn't decode string input"),
      ))
      .expect("Couldn't create public key hash!");

    // Call the supplied callback method under the passed class pointer
    env
      .call_method(
        &callback,
        "resolveCallback",
        "(Ljava/lang/String;)V",
        &[output.into()],
      )
      .unwrap();
  });

  // Wait until the thread has started.
  rx.recv().unwrap();
}

#[no_mangle]
pub extern "system" fn Java_com_numio_ZkSync_signMusig(
  env: JNIEnv,
  _class: JClass,
  callback: JObject,
  privateKey: JString,
  txnMsg: JString,
) {
  // Obtain the `JavaVM` interface
  let jvm = env.get_java_vm().unwrap();

  // Obtain global reference to the `callback` object before sending
  // it to the thread, to prevent it from being collected by the GC.
  let callback = env.new_global_ref(callback).unwrap();
  let private_key = env.new_global_ref(JObject::from(privateKey)).unwrap();
  let txn_msg = env.new_global_ref(JObject::from(txnMsg)).unwrap();

  // Use channel to prevent the Java program to finish before the thread
  // has chance to start.
  let (tx, rx) = mpsc::channel();

  let _ = thread::spawn(move || {
    // Signal that the thread has started.
    tx.send(()).unwrap();

    // Use the `JavaVM` interface to attach a `JNIEnv` to the current thread.
    let env = jvm.attach_current_thread().unwrap();

    // Get the string value from `private_key` after referencing the global pointer ref.
    let private_key_str: String = env
      .get_string(JString::from(private_key.as_obj()))
      .expect("Error converting string")
      .into();

    // Get the string value from `txn_msg` after referencing the global pointer ref.
    let txn_msg_str: String = env
      .get_string(JString::from(txn_msg.as_obj()))
      .expect("Error converting string")
      .into();

    // Get the main result after calling the inner function `private_key_to_pubkey_hash`
    let output = env
      .new_string(&sign_musig(
        &hex::decode(&private_key_str).expect("Couldn't decode private_key_str input"),
        &hex::decode(&txn_msg_str).expect("Couldn't decode private_key_str input"),
      ))
      .expect("Couldn't create signed transaction!");

    // Call the supplied callback method under the passed class pointer
    env
      .call_method(
        &callback,
        "resolveCallback",
        "(Ljava/lang/String;)V",
        &[output.into()],
      )
      .unwrap();
  });

  // Wait until the thread has started.
  rx.recv().unwrap();
}

#[no_mangle]
pub extern "system" fn Java_com_numio_ZkSync_privateKeyFromSeed(
  env: JNIEnv,
  _class: JClass,
  callback: JObject,
  seed: JString,
) {
  // Obtain the `JavaVM` interface
  let jvm = env.get_java_vm().unwrap();

  // Obtain global reference to the `callback` object before sending
  // it to the thread, to prevent it from being collected by the GC.
  let callback = env.new_global_ref(callback).unwrap();
  let seed_ref = env.new_global_ref(JObject::from(seed)).unwrap();

  // Use channel to prevent the Java program to finish before the thread
  // has chance to start.
  let (tx, rx) = mpsc::channel();

  let _ = thread::spawn(move || {
    // Signal that the thread has started.
    tx.send(()).unwrap();

    // Use the `JavaVM` interface to attach a `JNIEnv` to the current thread.
    let env = jvm.attach_current_thread().unwrap();

    // Get the string value from `private_key` after referencing the global pointer ref.
    let seed_hex_str: String = env
      .get_string(JString::from(seed_ref.as_obj()))
      .expect("Error converting string")
      .into();

    // Get the main result after calling the inner function `private_key_to_pubkey_hash`
    let output = env
      .new_string(&private_key_from_seed(
        &hex::decode(&seed_hex_str).expect("Couldn't decode hex seed input"),
      ))
      .expect("Couldn't create signed transaction!");

    // Call the supplied callback method under the passed class pointer
    env
      .call_method(
        &callback,
        "resolveCallback",
        "(Ljava/lang/String;)V",
        &[output.into()],
      )
      .unwrap();
  });

  // Wait until the thread has started.
  rx.recv().unwrap();
}

#[no_mangle]
pub extern "system" fn Java_com_numio_ZkSync_publicKeyFromPrivateKey(
  env: JNIEnv,
  _class: JClass,
  callback: JObject,
  privateKey: JString,
) {
  // Obtain the `JavaVM` interface
  let jvm = env.get_java_vm().unwrap();

  // Obtain global reference to the `callback` object before sending
  // it to the thread, to prevent it from being collected by the GC.
  let callback = env.new_global_ref(callback).unwrap();
  let private_key_ref = env.new_global_ref(JObject::from(privateKey)).unwrap();

  // Use channel to prevent the Java program to finish before the thread
  // has chance to start.
  let (tx, rx) = mpsc::channel();

  let _ = thread::spawn(move || {
    // Signal that the thread has started.
    tx.send(()).unwrap();

    // Use the `JavaVM` interface to attach a `JNIEnv` to the current thread.
    let env = jvm.attach_current_thread().unwrap();

    // Get the string value from `private_key` after referencing the global pointer ref.
    let private_key_hex_str: String = env
      .get_string(JString::from(private_key_ref.as_obj()))
      .expect("Error converting string")
      .into();

    // Get the main result after calling the inner function `private_key_to_pubkey_hash`
    let output = env
      .new_string(&private_key_to_pubkey(
        &hex::decode(&private_key_hex_str).expect("Couldn't decode hex seed input"),
      ))
      .expect("Couldn't create signed transaction!");

    // Call the supplied callback method under the passed class pointer
    env
      .call_method(
        &callback,
        "resolveCallback",
        "(Ljava/lang/String;)V",
        &[output.into()],
      )
      .unwrap();
  });

  // Wait until the thread has started.
  rx.recv().unwrap();
}
