abstract class MessageRepository {

  // constructor 와 factory 는 다르다. -> ::factory:: 유일하다는 뜻
  factory MessageRepository() => _MessageRepositoryImpl();


}

class _MessageRepositoryImpl implements MessageRepository{
  _MessageRepositoryImpl();
}