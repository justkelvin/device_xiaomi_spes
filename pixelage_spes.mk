#
# Copyright (C) 2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit from spes/spesn device
$(call inherit-product, device/xiaomi/spes/device.mk)

# Inherit some common Project Pixelage stuff.
$(call inherit-product, vendor/pixelage/config/common_full_phone.mk)

# MiuiCamera
$(call inherit-product, vendor/xiaomi/miuicamera/config.mk)

-include vendor/lineage-priv/keys/keys.mk

# Product Specifics
PRODUCT_NAME := pixelage_spes
PRODUCT_DEVICE := spes
PRODUCT_BRAND := Redmi
PRODUCT_MODEL := Redmi Note 11
PRODUCT_MANUFACTURER := Xiaomi

PRODUCT_GMS_CLIENTID_BASE := android-xiaomi

# Boot Animaton
TARGET_BOOT_ANIMATION_RES := 1080

# Project Pixelage Flags
PIXELAGE_BUILDTYPE := UNOFFICIAL

#Device Props
TARGET_FACE_UNLOCK_SUPPORTED := true
TARGET_SUPPORTS_QUICK_TAP := true

# Overlay
DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay-lineage

# Fingerprint
PRODUCT_BUILD_PROP_OVERRIDES += \
    DeviceName=spes_global \
    BuildDesc="spes_global-user 13 TKQ1.221114.001 V816.0.8.0.TGCMIXM:user release-keys" \
    BuildFingerprint=Redmi/spes_global/spes:13/TKQ1.221114.001/V816.0.8.0.TGCMIXM:user/release-keys