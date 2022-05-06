import ember
import h5py

ember_dir = "../data/ember2018/"

ember.create_vectorized_features(ember_dir)
X_train, y_train, X_test, y_test = ember.read_vectorized_features(ember_dir)

with h5py.File("../data/Ember2018.h5", 'w') as f:
    grp_train = f.create_group("train")
    grp_train.create_dataset("data", data = X_train.transpose())
    grp_train.create_dataset("targets", data = y_train)
    
    grp_test = f.create_group("test")
    grp_test.create_dataset("data", data = X_test.transpose())
    grp_test.create_dataset("targets", data = y_test)
