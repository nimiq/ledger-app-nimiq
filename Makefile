#*******************************************************************************
#   Ledger Nimiq App
#   (c) 2018 Ledger
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#*******************************************************************************

ifeq ($(BOLOS_SDK),)
$(error Environment variable BOLOS_SDK is not set)
endif

include $(BOLOS_SDK)/Makefile.defines


##############################
#      App description       #
##############################

# Application name
APPNAME = Nimiq

# Application version
APPVERSION_M = 1
APPVERSION_N = 4
APPVERSION_P = 6
APPVERSION = "$(APPVERSION_M).$(APPVERSION_N).$(APPVERSION_P)"

# Setting to allow building variant applications. For now, there are no variants, only the main Nimiq app.
VARIANT_PARAM = COIN
VARIANT_VALUES = nimiq


##############################
#       Source files         #
##############################

# Application source files
APP_SOURCE_PATH += src

# For now, don't include standard app files, as our code is not currently using the new common / standard app utilities,
# with the advantage of not including any utilities we don't use, but of the downside of having to maintain these common
# code utilities ourselves.
DISABLE_STANDARD_APP_FILES = 1

# Application icons following the guidelines:
# https://developers.ledger.com/docs/device-app/deliver/deliverables/icons
# Notes on how to create such icons in GIMP:
# - Open an SVG of the Nimiq logo and set the image width to the size of the safe area for the intended image size, e.g.
#   30px for the 32pxx32px image. Also import the paths.
# - Layer > Transparency > Remove Alpha Channel.
# - Edit > Fill the image with white.
# - Edit > Fill Path with black, or Select > From Path and fill the selection with a radial gradient, potentially with
#   an adequate offset set.
# - Set Image > Mode to indexed and for 1bit-per-pixel images (Nano devices) use a color palette with just black and
#   white, and for 4bit-per-pixel images (e-ink devices) use a color palette with 16 colors 0x00, 0x11, 0x22, ..., 0xff.
#   If desired, enable dithering and experiment with different modes. Mode "positioned" looks quite nice. For more
#   control, also Colors > Dither might be used.
# - Set the Layer > Layer Boundary Size to the intended size of the final image, centering the content. Then Image > Fit
#   Canvas to Layers.
# - Export the image as gif, which should be saved with the desired bits per pixel, if following these steps.
ICON_NANOS = icons/app_nimiq_16px.gif
ICON_NANOX = icons/app_nimiq_14px.gif
ICON_NANOSP = icons/app_nimiq_14px.gif
ICON_STAX = icons/app_nimiq_32px.gif
ICON_FLEX = icons/app_nimiq_40px.gif


##############################
#  Permissions and features  #
##############################

# Application allowed derivation curves.
CURVE_APP_LOAD_PARAMS = ed25519

# Application allowed derivation paths.
PATH_APP_LOAD_PARAMS = "44'/242'"

# See SDK `include/appflags.h` for the purpose of each permission
HAVE_APPLICATION_FLAG_GLOBAL_PIN = 1
#HAVE_APPLICATION_FLAG_BOLOS_SETTINGS = 1 # Automatically set in Makefile.standard_app for devices with bluetooth

ENABLE_BLUETOOTH = 1
ENABLE_NBGL_QRCODE = 1

# U2F
# U2F has been deprecated by Ledger, disabled in most apps and is not configured in $(BOLOS_SDK)/Makefile.standard_app,
# but we keep it for now as Nimiq is a browser centric coin, and Firefox and Safari don't support WebHID or WebUSB yet.
# Note though that U2F is somewhat memory hungry, apart from the significant UX flaws. Also see:
# https://www.ledger.com/windows-10-update-sunsetting-u2f-tunnel-transport-for-ledger-devices
# https://developers.ledger.com/docs/connectivity/ledgerJS/faq/U2F
DEFINES   += HAVE_IO_U2F
DEFINES   += U2F_PROXY_MAGIC=\"w0w\"
DEFINES   += U2F_REQUEST_TIMEOUT=28000 # 28 seconds
SDK_SOURCE_PATH += lib_u2f

# Enabling DEBUG flag will enable PRINTF and disable optimizations
# Instead of setting it here you can also enable this flag during compilation via `make DEBUG=1`
#DEBUG = 1

# Extend the base Makefile for standard apps
include $(BOLOS_SDK)/Makefile.standard_app

# Makes a detailed report of code and data size in debug/size-report.txt
# More useful for production builds with DEBUG=0
size-report: bin/app.elf
	arm-none-eabi-nm --print-size --size-sort --radix=d bin/app.elf >debug/size-report.txt
