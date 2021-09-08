import h5py
import numpy as np
import os
import torchvision

from torch.utils.data import DataLoader 
from torchvision.datasets import ImageNet
from torchvision import transforms
from torchvision.transforms import InterpolationMode
from tqdm import tqdm


def to_numpy(img):
    return np.transpose(np.array(img), (2, 1, 0))

def get_transform(image_size):
    return transforms.Compose([
        transforms.Resize(image_size, interpolation = InterpolationMode.BICUBIC),
        transforms.CenterCrop(image_size),
        transforms.Lambda(lambda img: to_numpy(img))
    ])

def get_loader(data, batch_size, num_workers):
    return DataLoader(
        data,
        batch_size = batch_size,
        shuffle = False,
        num_workers = num_workers,
        drop_last = False,
    )

def create_dataset(h5file, root, image_size = 224, batch_size = 100, num_workers = 0):
    path = os.path.dirname(h5file)
    if not os.path.exists(path):
        os.makedirs(path)
    
    f = h5py.File(h5file, mode='w')
    
    try:
        # Train
        print('Train data:')
        data_train = ImageNet(root, 'train', transform = get_transform(image_size))
        loader_train = get_loader(data_train, batch_size, num_workers)
        
        n_train = len(data_train)
        val_shape = (n_train, 3, image_size, image_size)
        
        f.create_dataset('train_data', val_shape, np.uint8)
        f.create_dataset('train_targets', (n_train,), np.int)
        
        for i, batch in enumerate(tqdm(loader_train)):
            inds = list(range(i*batch_size, min((i+1)*batch_size, n_train)))
            
            x = batch[0].detach().cpu().numpy()
            y = batch[1].detach().cpu().numpy() + 1
            
            f['train_data'][inds, ...] = x
            f['train_targets'][inds] = y
        
        # Validation
        print('Validation data:')
        data_val = ImageNet(root, 'val', transform = get_transform(image_size))
        loader_val = get_loader(data_val, batch_size, num_workers)
        
        n_val = len(data_val)
        val_shape = (n_val, 3, image_size, image_size)
        
        f.create_dataset('val_data', val_shape, np.uint8)
        f.create_dataset('val_targets', (n_val,), np.int)
        
        for i, batch in enumerate(tqdm(loader_val)):
            inds = list(range(i*batch_size, min((i+1)*batch_size, n_val)))
            
            x = batch[0].detach().cpu().numpy()
            y = batch[1].detach().cpu().numpy() + 1
            
            f['val_data'][inds, ...] = x
            f['val_targets'][inds] = y
    finally:
        f.close()


root = '/mnt/data/public_datasets/imagenet/imagenet_pytorch'
h5file = '/home/machava2/projects/DatasetProvider.jl/data/ImageNet224.h5'

create_dataset(h5file, root, image_size = 224, batch_size = 200, num_workers = 40)