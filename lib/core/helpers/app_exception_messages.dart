import 'package:firebase_core/firebase_core.dart';
import 'package:project_management_app/core/utils/app_exception.dart';
import 'package:project_management_app/core/utils/debug_prints.dart';

AppException handleFirebaseDatabaseExceptionMessages(FirebaseException e) {
  printInfo("CODE ${e.code}");
  switch (e.code) {
    case 'cancelled':
      printError('The operation was cancelled, typically by the caller.');
      return (AppException(
          errorMessage:
              'The operation was cancelled, typically by the caller.'));
    case 'unknown':
      printError('Unknown error or an error from a different error domain.');
      return (AppException(
          errorMessage:
              'Unknown error or an error from a different error domain.'));
    case 'invalid-argument':
      printError('Client specified an invalid argument.');
      return (AppException(
          errorMessage: 'Client specified an invalid argument.'));
    case 'deadline-exceeded':
      printError('Deadline expired before operation could complete.');
      return (AppException(
          errorMessage: 'Deadline expired before operation could complete.'));
    case 'not-found':
      printError('Some requested document was not found.');
      return (AppException(
          errorMessage: 'Some requested document was not found.'));
    case 'already-exists':
      printError('Some document that we attempted to create already exists.');
      return (AppException(
          errorMessage:
              'Some document that we attempted to create already exists.'));
    case 'permission-denied':
      printError(
          'The caller does not have permission to execute the specified operation.');
      return (AppException(
          errorMessage:
              'The caller does not have permission to execute the specified operation.'));
    case 'resource-exhausted':
      printError('Some resource has been exhausted.');
      return (AppException(errorMessage: 'Some resource has been exhausted.'));
    case 'failed-precondition':
      printError(
          'Operation was rejected because the system is not in a state required for the operation’s execution.');
      return (AppException(
          errorMessage:
              'Operation was rejected because the system is not in a state required for the operation’s execution.'));
    case 'aborted':
      printError(
          'The operation was aborted, typically due to a concurrency issue like transaction aborts.');
      return (AppException(
          errorMessage:
              'The operation was aborted, typically due to a concurrency issue like transaction aborts.'));
    case 'out-of-range':
      printError('Operation was attempted past the valid range.');
      return (AppException(
          errorMessage: 'Operation was attempted past the valid range.'));
    case 'unimplemented':
      printError('Operation is not implemented or not supported/enabled.');
      return (AppException(
          errorMessage:
              'Operation is not implemented or not supported/enabled.'));
    case 'internal':
      printError('Internal errors.');
      return (AppException(errorMessage: 'Internal errors.'));
    case 'unavailable':
      printError('The service is currently unavailable.');
      return (AppException(
          errorMessage: 'he service is currently unavailable.'));
    case 'data-loss':
      printError('Unrecoverable data loss or corruption.');
      return (AppException(
          errorMessage: 'Unrecoverable data loss or corruption.'));
    case 'unauthenticated':
      printError(
          'The request does not have valid authentication credentials for the operation.');
      return (AppException(
          errorMessage:
              'The request does not have valid authentication credentials for the operation.'));
    default:
      printError('An unknown error occurred: ${e.message}');
      return (AppException(
          errorMessage: 'An unknown error occurred: ${e.message}'));
  }
}
