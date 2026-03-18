import 'package:myapp/core/usecase/usecase.dart';
import 'package:myapp/core/utils/typedef.dart';
import 'package:myapp/features/ai_assistant/domain/repositories/ai_assistant_repository.dart';

class StartChatSession extends UseCaseWithoutParam<void> {
  const StartChatSession(this._repo);

  final AIAssistantRepository _repo;

  @override
  ResultVoid call() async => _repo.startChatSession();
}
