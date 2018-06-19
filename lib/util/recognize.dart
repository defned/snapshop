import 'package:mlkit/mlkit.dart';

enum VisionTextKind { unknown, price, discount, title, other }

class VisionTextInfo implements Comparable<VisionTextInfo> {
  VisionText vision;
  VisionTextKind kind;
  double likelihood;

  bool selected;

  @override
  int compareTo(VisionTextInfo other) =>
      likelihood.compareTo(other.likelihood) +
      ((vision.rect.size.width * vision.rect.size.height) -
              (other.vision.rect.size.width * other.vision.rect.size.height))
          .floor();
}
