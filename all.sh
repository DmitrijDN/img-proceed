#!/bin/bash

FOLDER_NAME=$(pwd)/receipt/

IMG_NAME=$FOLDER_NAME"receipt"
IMG_EXT=".jpg"
IMG_FULL_NAME=$IMG_NAME$IMG_EXT
IMG_OUTPUT=$IMG_NAME"_grayscaled"$IMG_EXT

OUTPUT_TEXT=$FOLDER_NAME/text

# IDENTIFY STAGE
echo "Identify stage"
identify -format "%w x %h %x x %y" $IMG_FULL_NAME
echo -e "\n$SPLITTER\n"

#CONVERT STAGE
echo "Convert stage"
CONVERT_OUTPUT=$IMG_NAME"_converted"$IMG_EXT
convert $IMG_FULL_NAME -units "PixelsPerInch" -density 300 -resample "300x" $CONVERT_OUTPUT
echo -e "\n$SPLITTER\n"

#GRAYSCALE STAGE
echo "Grayscale stage"
GRAYSCALE_OUTPUT=$IMG_NAME"_grayscale"$IMG_EXT
convert $IMG_FULL_NAME -type Grayscale $GRAYSCALE_OUTPUT
echo -e "\n$SPLITTER\n"

#GRAYSCALE OF DPI STAGE
echo "Grayscale DIP stage"
GRAYSCALE_DPI_OUTPUT=$IMG_NAME"_grayscale_dpi"$IMG_EXT
convert $CONVERT_OUTPUT -type Grayscale $GRAYSCALE_DPI_OUTPUT
echo -e "\n$SPLITTER\n"

#CROP
echo "CROP stage"
CROPPED_OUTPUT=$IMG_NAME"_crop"$IMG_EXT
python3 crop.py $IMG_FULL_NAME $CROPPED_OUTPUT
echo -e "\n$SPLITTER\n"

#CROPPED GRAYSCALE
echo "Grayscale Cropped stage"
GRAYSCALE_CROPPED_OUTPUT=$IMG_NAME"_grayscale_cropped"$IMG_EXT
convert $IMG_FULL_NAME -type Grayscale $GRAYSCALE_CROPPED_OUTPUT
echo -e "\n$SPLITTER\n"

#NOISE
echo "NOISE stage"
NOISED_OUTPUT=$IMG_NAME"_noise"$IMG_EXT
python3 noise.py $IMG_FULL_NAME $NOISED_OUTPUT
echo -e "\n$SPLITTER\n"


echo -e "\nTESSERACT PROCEEDING\n"

#TESSERACT USUAL
echo "Tesseract usual stage"
OUTPUT_TEXT_USUAL=$OUTPUT_TEXT"_usual"
tesseract $IMG_FULL_NAME $OUTPUT_TEXT_USUAL -l eng
echo -e "\n$SPLITTER\n"

#TESSERACT DPI
echo "Tesseract dpi stage"
OUTPUT_TEXT_DPI=$OUTPUT_TEXT"_dpi"
tesseract $CONVERT_OUTPUT $OUTPUT_TEXT_DPI -l eng
echo -e "\n$SPLITTER\n"

#TESSERACT GRAYSCALE
echo "Tesseract grayscale stage"
OUTPUT_TEXT_GRAYSCALE=$OUTPUT_TEXT"_grayscale"
tesseract $GRAYSCALE_OUTPUT $OUTPUT_TEXT_GRAYSCALE -l eng
echo -e "\n$SPLITTER\n"

#TESSERACT GRAYSCALE DPI
echo "Tesseract grayscale dpi stage"
OUTPUT_TEXT_GRAYSCALE_DPI=$OUTPUT_TEXT"_grayscale_dpi"
tesseract $GRAYSCALE_DPI_OUTPUT $OUTPUT_TEXT_GRAYSCALE_DPI -l eng
echo -e "\n$SPLITTER\n"

#TESSERACT CROPPED
echo "Tesseract cropped"
OUTPUT_TEXT_CROPPED=$OUTPUT_TEXT"_cropped"
tesseract $CROPPED_OUTPUT $OUTPUT_TEXT_CROPPED -l eng
echo -e "\n$SPLITTER\n"

#TESSERACT CROPPED
echo "Tesseract cropped"
OUTPUT_TEXT_CROPPED_GRAYSCALED=$OUTPUT_TEXT"_cropped_grayscaled"
tesseract $GRAYSCALE_CROPPED_OUTPUT $OUTPUT_TEXT_CROPPED_GRAYSCALED -l eng
echo -e "\n$SPLITTER\n"

#TESSERACT NOISE
echo "Tesseract noised"
OUTPUT_TEXT_NOISED=$OUTPUT_TEXT"_noised"
tesseract $CROPPED_OUTPUT $OUTPUT_TEXT_NOISED -l eng
echo -e "\n$SPLITTER\n"