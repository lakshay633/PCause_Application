import tensorflow as tf

# Load the Keras model
model = tf.keras.models.load_model("best_pcos_model.keras")

# Convert the model to TFLite format
converter = tf.lite.TFLiteConverter.from_keras_model(model)
tflite_model = converter.convert()

# Save the TFLite model
with open("best_pcos_model.tflite", "wb") as f:
    f.write(tflite_model)

print("Model converted to TFLite successfully!")
