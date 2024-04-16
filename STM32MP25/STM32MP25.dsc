# @file
#
#  Copyright (c) 2011 - 2020, ARM Limited. All rights reserved.
#  Copyright (c) 2024, Phan Ba Gia Bao <phanbagiabao2001@gmail.com>
#  Copyright (c) 2015 - 2021, Intel Corporation. All rights reserved.
#  Copyright (c) 2014, Linaro Limited. All rights reserved.
#
#  SPDX-License-Identifier: BSD-2-Clause-Patent
#
##

################################################################################
#
# Defines Section - statements that will be processed to create a Makefile.
#
################################################################################
[Defines]
  PLATFORM_NAME                  = STM32MP25
  PLATFORM_GUID                  = 7c581e8a-5bf5-4f7f-abb7-7f5b5a6e6a9d
  PLATFORM_VERSION               = 1.0
  DSC_SPECIFICATION              = 0x0001001A
  OUTPUT_DIRECTORY               = Build/$(PLATFORM_NAME)
  SUPPORTED_ARCHITECTURES        = AARCH64
  BUILD_TARGETS                  = DEBUG|RELEASE|NOOPT
  SKUID_IDENTIFIER               = DEFAULT
  FLASH_DEFINITION               = Platform/STM32/$(PLATFORM_NAME)/$(PLATFORM_NAME).fdf

  #
  # Defines for default states.  These can be changed on the command line.
  # -D FLAG=VALUE
  #
  DEFINE SECURE_BOOT_ENABLE      = FALSE
  DEFINE INCLUDE_TFTP_COMMAND    = FALSE
  DEFINE DEBUG_PRINT_ERROR_LEVEL = 0x8000004F

################################################################################
#
# Library Class section - list of all Library Classes needed by this Platform.
#
################################################################################

!include MdePkg/MdeLibs.dsc.inc

[LibraryClasses.common]
!if $(TARGET) == RELEASE
  DebugLib|MdePkg/Library/BaseDebugLibNull/BaseDebugLibNull.inf
!else
  DebugLib|MdePkg/Library/BaseDebugLibSerialPort/BaseDebugLibSerialPort.inf
!endif
  DebugPrintErrorLevelLib|MdePkg/Library/BaseDebugPrintErrorLevelLib/BaseDebugPrintErrorLevelLib.inf

  BaseLib|MdePkg/Library/BaseLib/BaseLib.inf
  PerformanceLib|MdePkg/Library/BasePerformanceLibNull/BasePerformanceLibNull.inf
  PrintLib|MdePkg/Library/BasePrintLib/BasePrintLib.inf
  PeCoffLib|MdePkg/Library/BasePeCoffLib/BasePeCoffLib.inf
  IoLib|MdePkg/Library/BaseIoLibIntrinsic/BaseIoLibIntrinsic.inf
  UefiDecompressLib|MdePkg/Library/BaseUefiDecompressLib/BaseUefiDecompressLib.inf

  #
  # It is not possible to prevent the ARM compiler from inserting calls to intrinsic functions.
  # This library provides the instrinsic functions such a compiler may generate calls to.
  #
  NULL|ArmPkg/Library/CompilerIntrinsicsLib/CompilerIntrinsicsLib.inf
  
  # Add support for GCC stack protector
  NULL|MdePkg/Library/BaseStackCheckLib/BaseStackCheckLib.inf

  # ARM Architectural Libraries
  CacheMaintenanceLib|ArmPkg/Library/ArmCacheMaintenanceLib/ArmCacheMaintenanceLib.inf
  ArmPlatformStackLib|ArmPlatformPkg/Library/ArmPlatformStackLib/ArmPlatformStackLib.inf
  ArmGenericTimerCounterLib|ArmPkg/Library/ArmGenericTimerPhyCounterLib/ArmGenericTimerPhyCounterLib.inf

  # Dual serial port library
  PL011UartClockLib|ArmPlatformPkg/Library/PL011UartClockLib/PL011UartClockLib.inf
  PL011UartLib|ArmPlatformPkg/Library/PL011UartLib/PL011UartLib.inf
  SerialPortLib|Platform/STM32/Library/SerialPortLib/SerialPortLib.inf

  #
  # Uncomment (and comment out the next line) For RealView Debugger. The Standard IO window
  # in the debugger will show load and unload commands for symbols. You can cut and paste this
  # into the command window to load symbols. We should be able to use a script to do this, but
  # the version of RVD I have does not support scripts accessing system memory.
  #
  #PeCoffExtraActionLib|ArmPkg/Library/RvdPeCoffExtraActionLib/RvdPeCoffExtraActionLib.inf
  PeCoffExtraActionLib|ArmPkg/Library/DebugPeCoffExtraActionLib/DebugPeCoffExtraActionLib.inf
  #PeCoffExtraActionLib|MdePkg/Library/BasePeCoffExtraActionLibNull/BasePeCoffExtraActionLibNull.inf

  DebugAgentLib|MdeModulePkg/Library/DebugAgentLibNull/DebugAgentLibNull.inf

  # Flattened Device Tree (FDT) access library
  FdtLib|EmbeddedPkg/Library/FdtLib/FdtLib.inf
 
[LibraryClasses.common.SEC]
  PcdLib|MdePkg/Library/BasePcdLibNull/BasePcdLibNull.inf
  BaseMemoryLib|MdePkg/Library/BaseMemoryLib/BaseMemoryLib.inf
  MemoryInitPeiLib|Platform/STM32/Library/MemoryInitPeiLib/MemoryInitPeiLib.inf
  PlatformPeiLib|ArmPlatformPkg/PlatformPei/PlatformPeiLib.inf
  ExtractGuidedSectionLib|EmbeddedPkg/Library/PrePiExtractGuidedSectionLib/PrePiExtractGuidedSectionLib.inf
  LzmaDecompressLib|MdeModulePkg/Library/LzmaCustomDecompressLib/LzmaCustomDecompressLib.inf
  PrePiLib|EmbeddedPkg/Library/PrePiLib/PrePiLib.inf
  HobLib|EmbeddedPkg/Library/PrePiHobLib/PrePiHobLib.inf
  PrePiHobListPointerLib|ArmPlatformPkg/Library/PrePiHobListPointerLib/PrePiHobListPointerLib.inf
  MemoryAllocationLib|EmbeddedPkg/Library/PrePiMemoryAllocationLib/PrePiMemoryAllocationLib.inf


###################################################################################################
# BuildOptions Section - Define the module specific tool chain flags that should be used as
#                        the default flags for a module. These flags are appended to any
#                        standard flags that are defined by the build process.
###################################################################################################

[BuildOptions]
  GCC:*_*_*_CC_FLAGS          = -DRPI_MODEL=4
  GCC:*_*_*_PP_FLAGS          = -DRPI_MODEL=4
  GCC:*_*_*_ASLPP_FLAGS       = -DRPI_MODEL=4
  GCC:*_*_*_ASLCC_FLAGS       = -DRPI_MODEL=4
  GCC:*_*_*_VFRPP_FLAGS       = -DRPI_MODEL=4
  GCC:RELEASE_*_*_CC_FLAGS    = -DMDEPKG_NDEBUG -DNDEBUG

[BuildOptions.common.EDKII.DXE_RUNTIME_DRIVER]
  GCC:*_*_AARCH64_DLINK_FLAGS = -z common-page-size=0x10000



################################################################################
#
# Pcd Section - list of all EDK II PCD Entries defined by this Platform
#
################################################################################
[PcdsFeatureFlag.common]
  # Use the Vector Table location in CpuDxe. We will not copy the Vector Table at PcdCpuVectorBaseAddress
  gArmTokenSpaceGuid.PcdRelocateVectorTable|FALSE

  gEmbeddedTokenSpaceGuid.PcdPrePiProduceMemoryTypeInformationHob|TRUE
  gEfiMdeModulePkgTokenSpaceGuid.PcdTurnOffUsbLegacySupport|TRUE

  ## If TRUE, Graphics Output Protocol will be installed on virtual handle created by ConsplitterDxe.
  #  It could be set FALSE to save size.
  gEfiMdeModulePkgTokenSpaceGuid.PcdConOutGopSupport|TRUE
  gEfiMdeModulePkgTokenSpaceGuid.PcdConOutUgaSupport|FALSE
  gEfiMdePkgTokenSpaceGuid.PcdUgaConsumeSupport|FALSE

[PcdsFixedAtBuild.common]
  gEfiMdePkgTokenSpaceGuid.PcdMaximumUnicodeStringLength|1000000
  gEfiMdePkgTokenSpaceGuid.PcdMaximumAsciiStringLength|1000000
  gEfiMdePkgTokenSpaceGuid.PcdMaximumLinkedListLength|1000000
  gEfiMdePkgTokenSpaceGuid.PcdSpinLockTimeout|10000000
  gEfiMdePkgTokenSpaceGuid.PcdDebugClearMemoryValue|0xAF
  gEfiMdePkgTokenSpaceGuid.PcdPerformanceLibraryPropertyMask|1
  gEfiMdePkgTokenSpaceGuid.PcdPostCodePropertyMask|0
  gEfiMdePkgTokenSpaceGuid.PcdUefiLibMaxPrintBufferSize|320

  # DEBUG_ASSERT_ENABLED       0x01
  # DEBUG_PRINT_ENABLED        0x02
  # DEBUG_CODE_ENABLED         0x04
  # CLEAR_MEMORY_ENABLED       0x08
  # ASSERT_BREAKPOINT_ENABLED  0x10
  # ASSERT_DEADLOOP_ENABLED    0x20
!if $(TARGET) == RELEASE
  gEfiMdePkgTokenSpaceGuid.PcdDebugPropertyMask|0x21
!else
  gEfiMdePkgTokenSpaceGuid.PcdDebugPropertyMask|0x2f
!endif

  #  DEBUG_INIT      0x00000001  // Initialization
  #  DEBUG_WARN      0x00000002  // Warnings
  #  DEBUG_LOAD      0x00000004  // Load events
  #  DEBUG_FS        0x00000008  // EFI File system
  #  DEBUG_POOL      0x00000010  // Alloc & Free (pool)
  #  DEBUG_PAGE      0x00000020  // Alloc & Free (page)
  #  DEBUG_INFO      0x00000040  // Informational debug messages
  #  DEBUG_DISPATCH  0x00000080  // PEI/DXE/SMM Dispatchers
  #  DEBUG_VARIABLE  0x00000100  // Variable
  #  DEBUG_BM        0x00000400  // Boot Manager
  #  DEBUG_BLKIO     0x00001000  // BlkIo Driver
  #  DEBUG_NET       0x00004000  // SNP Driver
  #  DEBUG_UNDI      0x00010000  // UNDI Driver
  #  DEBUG_LOADFILE  0x00020000  // LoadFile
  #  DEBUG_EVENT     0x00080000  // Event messages
  #  DEBUG_GCD       0x00100000  // Global Coherency Database changes
  #  DEBUG_CACHE     0x00200000  // Memory range cachability changes
  #  DEBUG_VERBOSE   0x00400000  // Detailed debug messages that may
  #                              // significantly impact boot performance
  #  DEBUG_ERROR     0x80000000  // Error
  gEfiMdePkgTokenSpaceGuid.PcdDebugPrintErrorLevel|$(DEBUG_PRINT_ERROR_LEVEL)

  gEfiMdePkgTokenSpaceGuid.PcdReportStatusCodePropertyMask|0x07

  #
  # Optional feature to help prevent EFI memory map fragments
  # Turned on and off via: PcdPrePiProduceMemoryTypeInformationHob
  # Values are in EFI Pages (4K). DXE Core will make sure that
  # at least this much of each type of memory can be allocated
  # from a single memory range. This way you only end up with
  # maximum of two fragments for each type in the memory map
  # (the memory used, and the free memory that was prereserved
  # but not used).
  #
  gEmbeddedTokenSpaceGuid.PcdMemoryTypeEfiACPIReclaimMemory|0
  gEmbeddedTokenSpaceGuid.PcdMemoryTypeEfiACPIMemoryNVS|0
  gEmbeddedTokenSpaceGuid.PcdMemoryTypeEfiReservedMemoryType|0
!if $(SECURE_BOOT_ENABLE) == TRUE
  gEmbeddedTokenSpaceGuid.PcdMemoryTypeEfiRuntimeServicesData|600
  gEmbeddedTokenSpaceGuid.PcdMemoryTypeEfiRuntimeServicesCode|400
  gEmbeddedTokenSpaceGuid.PcdMemoryTypeEfiBootServicesCode|1500
!else
  gEmbeddedTokenSpaceGuid.PcdMemoryTypeEfiRuntimeServicesData|300
  gEmbeddedTokenSpaceGuid.PcdMemoryTypeEfiRuntimeServicesCode|150
  gEmbeddedTokenSpaceGuid.PcdMemoryTypeEfiBootServicesCode|1000
!endif
  gEmbeddedTokenSpaceGuid.PcdMemoryTypeEfiBootServicesData|12000
  gEmbeddedTokenSpaceGuid.PcdMemoryTypeEfiLoaderCode|20
  gEmbeddedTokenSpaceGuid.PcdMemoryTypeEfiLoaderData|0

  gEmbeddedTokenSpaceGuid.PcdDmaDeviceOffset|0xc0000000

  gEfiMdeModulePkgTokenSpaceGuid.PcdFirmwareVersionString|L"EDK2-DEV"

!if $(SECURE_BOOT_ENABLE) == TRUE
  # override the default values from SecurityPkg to ensure images from all sources are verified in secure boot
  gEfiSecurityPkgTokenSpaceGuid.PcdOptionRomImageVerificationPolicy|0x04
  gEfiSecurityPkgTokenSpaceGuid.PcdFixedMediaImageVerificationPolicy|0x04
  gEfiSecurityPkgTokenSpaceGuid.PcdRemovableMediaImageVerificationPolicy|0x04
!endif

  #gEfiNetworkPkgTokenSpaceGuid.PcdAllowHttpConnections|TRUE

  # Default platform supported RFC 4646 languages: (American) English
  gEfiMdePkgTokenSpaceGuid.PcdUefiVariableDefaultPlatformLangCodes|"en-US"

  gEmbeddedTokenSpaceGuid.PcdInterruptBaseAddress|0x40000000
  gArmTokenSpaceGuid.PcdArmArchTimerSecIntrNum|0x0
  gArmTokenSpaceGuid.PcdArmArchTimerIntrNum|0x1
  gArmTokenSpaceGuid.PcdArmArchTimerVirtIntrNum|0x3
  gArmTokenSpaceGuid.PcdArmArchTimerHypIntrNum|0x2

[LibraryClasses.common]
  ArmLib|ArmPkg/Library/ArmLib/ArmBaseLib.inf
  ArmMmuLib|ArmPkg/Library/ArmMmuLib/ArmMmuBaseLib.inf
  ArmPlatformLib|Platform/STM32/Library/STM32MP25Lib/STM32MP25Lib.inf
  TimerLib|ArmPkg/Library/ArmArchTimerLib/ArmArchTimerLib.inf

[PcdsPatchableInModule]
  gEfiMdeModulePkgTokenSpaceGuid.PcdSerialClockRate|500000000

################################################################################
#
# Pcd Section - list of all EDK II PCD Entries defined by this Platform
#
################################################################################
[PcdsFeatureFlag.common]
  gEfiMdeModulePkgTokenSpaceGuid.PcdConOutGopSupport|TRUE
  gEfiMdeModulePkgTokenSpaceGuid.PcdConOutUgaSupport|FALSE
  gEfiMdeModulePkgTokenSpaceGuid.PcdInstallAcpiSdtProtocol|TRUE

[PcdsFixedAtBuild.common]
  gArmPlatformTokenSpaceGuid.PcdCoreCount|4
  gArmTokenSpaceGuid.PcdVFPEnabled|1

   # Stacks for MPCores in Normal World
  gArmPlatformTokenSpaceGuid.PcdCPUCoresStackBase|0x88000000
  gArmPlatformTokenSpaceGuid.PcdCPUCorePrimaryStackSize|0x40000
  gEfiMdeModulePkgTokenSpaceGuid.PcdMaxVariableSize|0x2000
  gArmPlatformTokenSpaceGuid.PcdCPUCoreSecondaryStackSize|0x0
  gEfiMdeModulePkgTokenSpaceGuid.PcdMaxAuthVariableSize|0x2800

    # System Memory (2GB) - Reserved Secure Memory (16MB)
  gArmTokenSpaceGuid.PcdSystemMemoryBase|0x86000000
  gArmTokenSpaceGuid.PcdSystemMemorySize|(0x860000000 - 0x01000000)

    # GIC Base Addresses
  gArmTokenSpaceGuid.PcdGicInterruptInterfaceBase|0x4ac00000
  gArmTokenSpaceGuid.PcdGicDistributorBase|0x4ac100000
  #gArmTokenSpaceGuid.PcdGicRedistributorsBase|0x300C0000


################################################################################
#
# Components Section - list of all EDK II Modules needed by this Platform
#
################################################################################
[Components.common]
  #
  # PEI Phase modules
  #
  ArmPlatformPkg/PrePi/PeiUniCore.inf  
 


