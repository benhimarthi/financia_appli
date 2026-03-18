import 'package:myapp/core/usecase/usecase.dart';
import 'package:myapp/core/utils/typedef.dart';
import 'package:myapp/features/ai_assistant/domain/repositories/ai_assistant_repository.dart';

class ClearChatSession extends UseCaseWithoutParam<void> {
  const ClearChatSession(this._repo);

  final AIAssistantRepository _repo;

  @override
  ResultVoid call() async => _repo.clearChatSession();
}
