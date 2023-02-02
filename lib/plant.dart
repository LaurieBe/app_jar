class Plant {
  const Plant( 
      {required this.name,
      this.scientificName,
      this.type,
      this.size,
      this.exposure,
      this.hardiness,
      this.ph,
      this.soil,
      this.watering,
      this.area, 
      this.color, 
      this.flowerBegin, 
      this.flowerEnd, 
      this.fruitEnd, 
      this.fruitBegin, 
      this.leavesEnd, 
      this.leavesBegin, 
      this.wish, 
      this.comment, 
      this.persistence, 
      this.leavesDescription,});
  final String name;
  final String? scientificName;
  final String? type;
  final double? size;
  final String? exposure;
  final String? soil;
  final String? ph;
  final String? watering;
  final String? hardiness;
  final String? area;
  final String? color;
  final String? flowerBegin;
  final String? flowerEnd;
  final String? fruitEnd;
  final String? fruitBegin;
  final String? leavesEnd;
  final String? leavesBegin;
  final String? wish;
  final String? comment;
  final String? persistence;
  final String? leavesDescription;
}
