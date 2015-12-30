function list=listImageFiles(path)

% La ruta tiene que ser relativa
list = [ dir([path,'/*.png']) ; dir([path,'/*.tif']) ; dir([path,'/*.bmp']) ];
