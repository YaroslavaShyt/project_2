class CameraConfigData {
  final bool isVideoCamera;
  final bool isPhotoCamera;
  final Function? onVideoCameraSuccess;
  final Function? onVideoCameraError;
  final Function? onPhotoCameraError;
  final Function? onPhotoCameraSuccess;

  CameraConfigData({
    required this.isVideoCamera,
    required this.isPhotoCamera,
    this.onVideoCameraSuccess,
    this.onVideoCameraError,
    this.onPhotoCameraError,
    this.onPhotoCameraSuccess,
  });
}
