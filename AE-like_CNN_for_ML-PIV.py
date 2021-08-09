'''
This is a sample code for constructing AE-like CNN utilized in Morimoto et al., "Experimental velocity data estimation for imperfect particle images using machine learning," Phys. Fluids, 2021.

x_num: number of collocation points in x direction
y_num: number of collocation points in y direction
X: input particle image (batch, x_num, y_num, 1)
y: output velocity field {u,v} (batch, x_num, y_num, 2)
'''

import numpy as np
import pandas as pd
import tensorflow as tf

from keras.layers import Input, Conv2D, MaxPooling2D, UpSampling2D
from keras.models import Model
from sklearn.model_selection import train_test_split
from keras import backend as K
from keras.callbacks import TensorBoard
from keras.callbacks import ModelCheckpoint,EarlyStopping
from keras.models import load_model

# define a model
filenm = 'AE-like_CNN_for_ML-PIV'
X_train,X_test,y_train,y_test = train_test_split(X, y, test_size=0.3, random_state=None)
input_img = Input(shape=(x_num, y_num, 1))
act = 'relu'

x = Conv2D(32, (5, 5), activation=act, padding='same')(input_img)
x = Conv2D(32, (5, 5), activation=act, padding='same')(x)
x = MaxPooling2D((5, 5), padding='same')(x)
x = Conv2D(32, (5, 5), activation=act, padding='same')(x)
x = Conv2D(32, (5, 5), activation=act, padding='same')(x)
x = MaxPooling2D((2, 2), padding='same')(x)
x = Conv2D(32, (5, 5), activation=act, padding='same')(x)
x = Conv2D(32, (5, 5), activation=act, padding='same')(x)
x = MaxPooling2D((2, 2), padding='same')(x)
x = Conv2D(16, (3, 3), activation=act, padding='same')(x)
x = Conv2D(16, (3, 3), activation=act, padding='same')(x)
x = UpSampling2D((2, 2))(x)
x = Conv2D(32, (5, 5), activation=act, padding='same')(x)
x = Conv2D(32, (5, 5), activation=act, padding='same')(x)
x = UpSampling2D((2, 2))(x)
x = Conv2D(32, (5, 5), activation=act, padding='same')(x)
x = Conv2D(32, (5, 5), activation=act, padding='same')(x)
x = UpSampling2D((5, 5))(x)
x = Conv2D(32, (5, 5), activation=act, padding='same')(x)
x = Conv2D(2, (5, 5), activation='linear', padding='same')(x)

model = Model(input_img, x)
model.compile(optimizer='adam', loss='mse')

tempfn_model=filenm+'.hdf5'
model_cb=ModelCheckpoint(tempfn_model,
                         monitor='val_loss',
                         save_best_only=True,
                         verbose=1)
early_cb=EarlyStopping(monitor='val_loss',
                       patience=20,
                       verbose=1)
cb = [model_cb, early_cb]

history=model.fit(X_train, y_train,
                  epochs=3000,
                  batch_size=10,
                  shuffle=True,
                  validation_data=(X_test, y_test),
                  callbacks=cb,
                  verbose=1)

df_results = pd.DataFrame(history.history)
df_results['epoch'] = history.epoch
tempfn_history = filenm+'.csv'
df_results.to_csv(path_or_buf=tempfn_history,index=False)