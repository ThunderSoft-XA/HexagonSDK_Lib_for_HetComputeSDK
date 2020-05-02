# HexagonSDK_Lib_for_HetComputeSDK

Basic Information: The is a Qualcomm HexagonSDK project for HetComputeSDK. It is include DSP code.

PlatformInfo: MSM8998, MSM8996, SDM660, SDM845.

Host BuildInfo: Unbuntu 18.04LTS

Maintainer: Shen Tao, Yang Rong

Start date: june 10th, 2019.

Function description: This is a Qualcomm HexagonSDK application and library for DSP hardware.
                      It will test the function if the DSP is work and add new functions to library for HetCompute application.
                      
Application Sourcecode folder introduction:
1. HetCompute_dsp: This is a total folder and it include all applicatione and library files.
2. glue: Folder include some build file(mak and min), It will build the HexagonSDK code.
3. inc: Folder include some header files for hexagon application and library.
4. src: Folder include some source code files.
5. HetCompute_dsp_walkthrough_32bit.py and HetCompute_dsp_walkthrough_64bit.py: This is python script, build code and push to DUT.

Build and running:

Build:
1. Download "qualcomm_hexagon_sdk_3_3_3_linux"
2. Enter "Qualcomm/Hexagon_SDK/3.3.3" folder and run command: source setup_sdk_env.source
3. Connect DUT by host PC. Enter "Qualcomm/Hexagon_SDK/3.3.3/examples/common/HetCompute_dsp" folder.
4. Run command: python HetCompute_dsp_walkthrough_32bit.py or python HetCompute_dsp_walkthrough_64bit.py
5. library, application and other setting will be push to DUT.
6. Build out: Success build will create out application and library.
              android_Debug(32-bit application and library), android_Debug_aarch64(64-bit application and library)
              hexagon_Debug_dynamic_toolv***: Folder include DSP driver library.

Running:
1. Application will be push to /vendor/bin folder.
