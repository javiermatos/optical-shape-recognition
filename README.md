# Optical Shape Recognition

This is a demonstration about an optical shape recognition created with [MATLAB](http://www.mathworks.com/products/matlab/) using different toolboxes:

 - **Neural Network**: the recognition engine of this tool was created using a multilayer neural network.
 - **Image Acquisition**/**Image Processing**:  with this two toolboxes we can extract shapes within images and analyze their properties to create the input needed to the neural network.


I have created some useful functions to extract advanced properties of shapes explained in the literature of computer vision and image processing. [Harris](http://docs.opencv.org/2.4/doc/tutorials/features2d/trackingmotion/harris_detector/harris_detector.html) [corner detector](http://en.wikipedia.org/wiki/Corner_detection) is an example of function done to extract properties from shapes.


## Using the MATLAB Command Line Interface

The steps needed to learn and recognize shapes are as follows:


### 1. Extract properties from shapes

Suppose that we have a folder with binary images. Each image contains a shape that we want to recognize. The first step is to extract characteristics from shapes within images.

```matlab
% A binary image example
imshow('F.png')

% Characteristics extraction
imagesPath = '/home/myuser/symbols/characters';
exhaustive = true; % extract more characteristics from shapes
progressBar = false; % show a progress bar
verbose = true; % verbose output

[Map,Data] = performCharacteristicsExtraction(imagesPath, exhaustive, progressBar, verbose);
```

![Extract properties from shapes](/doc/osr_demo_01.png?raw=true)


### 2. Analyze data acquired from shapes

We can perform a [principal component analysis](http://en.wikipedia.org/wiki/Principal_component_analysis) using extracted data from shapes to know if differences are enough to recognize shapes.

```matlab
% PCA computation
[coeff, score] = princomp(Data.input');

clf; hold on;

% Colors
colorBase = [ 'b' ; 'g' ; 'r' ; 'c' ; 'm' ; 'y' ];

for i=1:unique(max(Data.output))
    plot(  score(Data.output == i,1), ...
           score(Data.output == i,2), ...
           '.','Color',colorBase(mod(i-1,length(colorBase))+1));
end
```

![Analyze data acquired from shapes](/doc/osr_demo_02.png?raw=true)


### 3. Training neural Network

Now that we have the input and the desired output we can perform the learning process using the neural network.

```matlab
% Generates the trained neural network
Engine = performLearning(Data);
```


### 4. Shape recognition

Now we load the image that contains shapes that we want to recognize.

```matlab
% Read input image
image = imread('test.png');

% Extract shapes from input image
Shapes = performRecognition(Engine, Map, image);
```


### 5. Show results

Finally, we show the results drawing some overlays over the recognized shapes.

```matlab
clf; imshow(image); hold on;

% For every shape in the image we show the associated label
for i=1:length(Shapes)
    text(Shapes(i).Centroid(1),Shapes(i).Centroid(2),[' \leftarrow ',Shapes(i).Label],'FontSize',18,'Color',colorBase(mod(i-1,length(colorBase))+1));
end
```

![Show results](/doc/osr_demo_03.png?raw=true)


## Graphical User Interface

The graphical user interface let you perform previous steps in a friendly way. To start it run `launch.m` file that is in the main directory.

![Graphical User Interface](/doc/gui.png?raw=true)

