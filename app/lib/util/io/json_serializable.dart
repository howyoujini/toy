// Serializable(직렬화) 인터페이스를 보면 메소드가 하나도 없는데 이 친구가 필요한 이유는
// 우리가 만든 클래스가 파일에 읽거나 쓸 수 있도록 하거나, 다른 서버로 보내거나 받을 수 있도록 하기 위해

abstract class JsonSerializable {
  Map<String, dynamic> toJson();
}

