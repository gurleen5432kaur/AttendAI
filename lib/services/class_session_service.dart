import '../models/class_session_model.dart';

class ClassSessionService {
  ClassSessionService._();

  static final ClassSessionService instance =
  ClassSessionService._();

  ClassSessionModel? currentSession;
}