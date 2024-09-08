{
  callPackage,
  sources,
  fetchpatch2,
  ...
}:
let
  pipeline = callPackage ./pipeline { };
in
{
  amazon-fire-hd-karnak = pipeline {
    anyKernelVariant = "osm0sis";
    enableKernelSU = false;
    kernelDefconfigs = [ "lineageos_karnak_defconfig" ];
    kernelImageName = "Image.gz-dtb";
    kernelMakeFlags = [
      "KCFLAGS=\"-w\""
      "KCPPFLAGS=\"-w\""
    ];
    kernelSrc = sources.linux-amazon-karnak.src;
    oemBootImg = boot/amazon-fire-hd-karnak.img;
  };

  moto-rtwo-lineageos-21 = pipeline {
    anyKernelVariant = "kernelsu";
    clangVersion = "latest";
    kernelDefconfigs = [
      "gki_defconfig"
      "vendor/kalama_GKI.config"
      "vendor/ext_config/moto-kalama.config"
      "vendor/ext_config/moto-kalama-gki.config"
      "vendor/ext_config/moto-kalama-rtwo.config"
    ];
    kernelImageName = "Image";
    kernelSrc = sources.linux-moto-rtwo-lineageos-21.src;
  };

  # still require some patches
  moto-pstar-lineageos-21 = pipeline {
    anyKernelVariant = "kernelsu";
    clangVersion = "latest";
    kernelPatches = builtins.map fetchpatch2 [
        {
          url = "https://raw.githubusercontent.com/AndroidAppsUsedByMyself/kernel_patches/main/patches/4.19.157/0001-merge-defconfig-for-pstar.patch";
          hash = "sha256-BkuyXnSaNJrc5s7a5WDbyJTdVBek9fZt0OUZ/EEyF/o=";
        }
        {
          url = "https://raw.githubusercontent.com/AndroidAppsUsedByMyself/kernel_patches/main/patches/4.19.157/0001-update-dtc-to-v1.6.1.patch";
          hash = "sha256-gjeOEidz/vaAJojUSrtTP3Wca/UtP7XYjmsHCyhgdEU=";
        }
      ];
    kernelDefconfigs = [
      "vendor/lineageos_pstar_defconfig"
    ];
    kernelImageName = "Image";
    kernelSrc = sources.linux-moto-pstar-lineageos-21.src;
  };

  oneplus-8t-blu-spark = pipeline {
    anyKernelVariant = "osm0sis";
    clangVersion = "latest";
    kernelDefconfigs = [ "blu_spark_defconfig" ];
    kernelImageName = "Image";
    kernelSrc = sources.linux-oneplus-8t-blu-spark.src;
    kernelConfig = ''
      CONFIG_STACKPROTECTOR=n
      CONFIG_LTO_CLANG=y
    '';
  };
}
