// #![cfg(target_os = "android")]
#![allow(non_snake_case)]
use crate::sign::private_key_to_pubkey_hash;
use jni::objects::{GlobalRef, JClass, JObject, JString};
use jni::sys::{jlong, jstring};
use jni::JNIEnv;
use std::sync::mpsc;
use std::thread;

// struct CallbackWrapper {
//   callback: GlobalRef,
// }
//
// impl CallbackWrapper {
//   pub fn new(callback: GlobalRef) -> CallbackWrapper {
//     CallbackWrapper { callback }
//   }
//
//   pub fn resolve(&mut self, env: JNIEnv, result: String) {
//     let result = env
//       .new_string(result)
//       .expect("Error converting result to be returned");
//     env
//       .call_method(&self.callback, "resolveCallback", "(S)S", &[result.into()])
//       .expect("Error calling resolveCallback method");
//   }
//
//   pub fn reject(&mut self, env: JNIEnv, result: String) {
//     let result = env
//       .new_string(result)
//       .expect("Error converting result to be returned");
//     env
//       .call_method(&self.callback, "rejectCallback", "(S)S", &[result.into()])
//       .expect("Error calling rejectCallback method");
//   }
// }
//
// #[no_mangle]
// pub unsafe extern "system" fn Java_ZkSync_newCallbackWrapper(
//   env: JNIEnv,
//   _class: JClass,
//   callback: JObject,
// ) -> jlong {
//   let global_ref = env.new_global_ref(callback).unwrap();
//   let callbackWrapper = CallbackWrapper::new(global_ref);
//
//   Box::into_raw(Box::new(callbackWrapper)) as jlong
// }
//
// #[no_mangle]
// pub unsafe extern "system" fn Java_ZkSync_privateKeyToPublicKeyHash(
//   env: JNIEnv,
//   _class: JClass,
//   privateKey: JString,
// ) -> jstring {
//   let private_key_str: String = env
//     .get_string(privateKey)
//     .expect("Error converting string")
//     .into();
//
//   let output = env
//     .new_string(&private_key_to_pubkey_hash(&private_key_str.into_bytes()))
//     .expect("Couldn't create public key hash!");
//
//   output.into_inner()
// }

#[no_mangle]
pub extern "system" fn Java_com_numio_ZkSync_privateKeyToPublicKeyHash(
  env: JNIEnv,
  _class: JClass,
  callback: JObject,
  privateKey: JString,
) {
  // `JNIEnv` cannot be sent across thread boundaries. To be able to use JNI
  // functions in other threads, we must first obtain the `JavaVM` interface
  // which, unlike `JNIEnv` is `Send`.
  let jvm = env.get_java_vm().unwrap();

  // We need to obtain global reference to the `callback` object before sending
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

    let private_key_str: String = env
      .get_string(JString::from(private_key.as_obj()))
      .expect("Error converting string")
      .into();

    // let output = private_key_to_pubkey_hash(
    //   &hex::decode(&private_key_str).expect("Couldn't decode string input"),
    // );

    let output = env
      .new_string(&private_key_to_pubkey_hash(
        &hex::decode(&private_key_str).expect("Couldn't decode string input"),
      ))
      .expect("Couldn't create public key hash!");

    // println!("{:?}", output);
    // Now we can use all available `JNIEnv` functionality normally.
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
