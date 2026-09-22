// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Easy Agent';

  @override
  String get gatewayUrl => 'Gateway URL';

  @override
  String get tokenLabel => 'Token';

  @override
  String get connect => 'Connect';

  @override
  String get connecting => 'Connecting...';

  @override
  String get search => 'Search';

  @override
  String get searchHint => 'Search session name';

  @override
  String get recent => 'Recent';

  @override
  String get me => 'me';

  @override
  String get tabChat => 'Chat';

  @override
  String get tabConfig => 'Config';

  @override
  String loadError(String arg1) {
    return 'Load failed: $arg1';
  }

  @override
  String get markRead => 'Mark as read';

  @override
  String get typeMessage => 'Type a message...';

  @override
  String get chatTitle => 'Chat';

  @override
  String get thinkLabel => 'Thinking';

  @override
  String get compactedLabel => 'History compacted · view summary';

  @override
  String get copied => 'Copied';

  @override
  String get copy => 'Copy';

  @override
  String get error => 'Error';

  @override
  String get undo => 'Undo';

  @override
  String get retry => 'Retry';

  @override
  String get editMessage => 'Edit message';

  @override
  String get undoTitle => 'Undo this message?';

  @override
  String get undoBody => 'This deletes the message and everything after it.';

  @override
  String get retryTitle => 'Resend this message?';

  @override
  String get retryBody =>
      'This withdraws the message and everything after it, then resends the original text.';

  @override
  String get cancel => 'Cancel';

  @override
  String get apply => 'Apply';

  @override
  String get delete => 'Delete';

  @override
  String get loading => 'Loading...';

  @override
  String get loadEarlier => 'Load earlier';

  @override
  String get thinking => 'thinking...';

  @override
  String get running => 'running...';

  @override
  String sendFailed(String arg1) {
    return 'Send failed: $arg1';
  }

  @override
  String get send => 'Send';

  @override
  String get attach => 'Attach file';

  @override
  String get dropToAttach => 'Drop to add as attachment';

  @override
  String get followSystem => 'Follow system';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get folderNotAllowed =>
      'Folders can\'t be attached — drop individual files';

  @override
  String get image => 'image';

  @override
  String get takePhoto => 'Take photo';

  @override
  String get chooseImage => 'Choose from gallery';

  @override
  String get chooseFile => 'Choose file';

  @override
  String uploadFailedRetry(String arg1) {
    return '$arg1 attachment(s) failed to upload — retry or remove them before sending';
  }

  @override
  String get compactHistory => 'Compact history';

  @override
  String get mailbox => 'Mailbox';

  @override
  String get container => 'Container';

  @override
  String get deleteSession => 'Delete session';

  @override
  String get historyCompacted => 'History compacted';

  @override
  String get nothingToCompact => 'Nothing to compact — history is short';

  @override
  String get back => 'Back';

  @override
  String get refresh => 'Refresh';

  @override
  String get taskDone => 'Done';

  @override
  String get settingsTitle => 'Session Settings';

  @override
  String get modelLabel => 'Model';

  @override
  String get variantLabel => 'Reasoning variant';

  @override
  String get variantNone => 'Default (no variant)';

  @override
  String get presetLabel => 'Preset';

  @override
  String get deleteSessionTitle => 'Delete session';

  @override
  String deleteSessionBody(String arg1) {
    return 'Delete session \"$arg1\"?';
  }

  @override
  String get deleteSessionsTitle => 'Delete sessions';

  @override
  String deleteSessionsBody(String arg1) {
    return 'Delete $arg1 selected sessions? This cannot be undone.';
  }

  @override
  String get selectSessions => 'Select';

  @override
  String get selectAll => 'Select all';

  @override
  String selectedCount(String arg1) {
    return '$arg1 selected';
  }

  @override
  String get addModel => 'Add model';

  @override
  String get holdToTalk => 'Hold to talk';

  @override
  String get releaseToSend => 'Release to send';

  @override
  String get abort => 'Abort';

  @override
  String get edit => 'Edit';

  @override
  String get voiceMode => 'Voice';

  @override
  String get keyboardMode => 'Keyboard';

  @override
  String get voicePermission => 'Microphone permission denied';

  @override
  String get voiceTooShort => 'Recording too short';

  @override
  String get uploading => 'Uploading…';

  @override
  String get uploadFailed => 'Upload failed';

  @override
  String get capText => 'text';

  @override
  String get capImage => 'image';

  @override
  String get capVideo => 'video';

  @override
  String get capSpeech => 'speech';

  @override
  String get capTranscription => 'ASR';

  @override
  String get capEmbedding => 'embedding';

  @override
  String get capReranking => 'rerank';

  @override
  String get capRealtime => 'realtime';

  @override
  String get fork => 'Fork';

  @override
  String failed(String arg1) {
    return 'Failed: $arg1';
  }

  @override
  String get settings => 'Settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get llm => 'LLM';

  @override
  String get llmProviders => 'Providers';

  @override
  String get providers => 'Providers';

  @override
  String get presets => 'Presets';

  @override
  String get workspace => 'Workspace';

  @override
  String get tools => 'Tools';

  @override
  String get language => 'Language';

  @override
  String get switchBackend => 'Switch user';

  @override
  String get backendsTitle => 'Users';

  @override
  String get noSavedBackends => 'No saved users yet.';

  @override
  String get addBackend => 'Add new user';

  @override
  String get addBackendHint => 'Sign in with a different URL and token';

  @override
  String get deleteBackend => 'Remove user';

  @override
  String get backendSection => 'Backend';

  @override
  String get providerTemplate => 'Template (models.dev)';

  @override
  String get providerTemplateHint => 'Pick a provider to prefill';

  @override
  String get searchModels => 'Search models...';

  @override
  String get noProviders => 'No providers. Add one to get started.';

  @override
  String get addProvider => 'Add Provider';

  @override
  String modelsCount(String arg1) {
    return '$arg1 models';
  }

  @override
  String get providerId => 'Provider ID';

  @override
  String get providerIdReq => 'Provider ID (required)';

  @override
  String get apiType => 'API Type';

  @override
  String get apiTypeOpenai => 'OpenAI';

  @override
  String get apiTypeAnthropic => 'Anthropic';

  @override
  String get apiTypeGemini => 'Gemini';

  @override
  String get baseUrl => 'Base URL';

  @override
  String get apiKey => 'API Key';

  @override
  String get test => 'Test';

  @override
  String get testing => 'Testing...';

  @override
  String get register => 'Register';

  @override
  String get registering => 'Registering...';

  @override
  String get saved => 'Saved';

  @override
  String get noConfig => 'no config';

  @override
  String get configured => 'configured';

  @override
  String get needsConfig => 'needs config';

  @override
  String get newPreset => 'New preset';

  @override
  String get presetId => 'Preset id...';

  @override
  String get create => 'Create';

  @override
  String get noPresets => 'No presets.';

  @override
  String get deletePreset => 'Delete preset';

  @override
  String deletePresetBody(String arg1) {
    return 'Delete preset $arg1?';
  }

  @override
  String presetSummary(String arg1, String arg2) {
    return '$arg1 turns · $arg2 tools';
  }

  @override
  String get systemPrompt => 'System Prompt';

  @override
  String get maxTurns => 'Max turns';

  @override
  String get terminal => 'Terminal';

  @override
  String get close => 'Close';

  @override
  String get noSession => 'No session';

  @override
  String get history => 'History';

  @override
  String get none => 'None';

  @override
  String get download => 'Download';

  @override
  String get noMessages => 'No messages';

  @override
  String get consumed => 'consumed';

  @override
  String get pending => 'Pending';

  @override
  String savedToDownloads(String arg1) {
    return 'Saved to Downloads: $arg1';
  }

  @override
  String get timeJustNow => 'just now';

  @override
  String timeMinAgo(String arg1) {
    return '$arg1 min ago';
  }

  @override
  String timeHour(String arg1) {
    return '$arg1 h ago';
  }

  @override
  String timeDay(String arg1) {
    return '$arg1 d ago';
  }

  @override
  String get baseUrlReq => 'Base URL (required)';

  @override
  String get apiKeyReq => 'API Key (required)';

  @override
  String get save => 'Save';

  @override
  String get noTools => 'No tools';

  @override
  String get agentLocale => 'Agent language';

  @override
  String get agentLocaleFollow => 'Follow (UI language)';

  @override
  String agentLocaleApplied(String l) {
    return 'Agent language set to $l';
  }

  @override
  String get toolParams => 'Parameters';

  @override
  String get showMore => 'Show';

  @override
  String get showLess => 'Collapse';

  @override
  String get systemPresetBadge => 'System';

  @override
  String get readOnlyPreset => 'System preset: read-only';

  @override
  String get sysPromptByPreset =>
      'System prompt is determined by the selected preset.';

  @override
  String get requiredConfig => 'required config';

  @override
  String get selectProviderFirst => 'Select a provider first';

  @override
  String get apiTypeOpenaiCompat => 'OpenAI Compatible';

  @override
  String get modelsLabel => 'Models';

  @override
  String get modelIdLabel => 'model id…';

  @override
  String get contextLengthLabel => 'context';

  @override
  String get contextLengthRequired =>
      'Context length is required (positive number).';

  @override
  String get add => 'Add';

  @override
  String get turnsByPreset => 'Max turns is set by the selected preset.';

  @override
  String testModelOk(Object arg1) {
    return 'Model OK: $arg1';
  }

  @override
  String connectionError(Object arg1) {
    return 'Connection error: $arg1';
  }

  @override
  String get toolInputParams => 'Input';

  @override
  String get content => 'Content';

  @override
  String get metadata => 'Metadata';

  @override
  String get newSession => 'New session';

  @override
  String get noSessions => 'No sessions';

  @override
  String get apiTypeGateway => 'Vercel AI Gateway';

  @override
  String get apiTypeDeepseek => 'DeepSeek';

  @override
  String get apiTypeCohere => 'Cohere';

  @override
  String get capabilityLabel => 'Modality';

  @override
  String get nonTextModelHint =>
      'Non-text models are used by tools; no context window.';

  @override
  String get modelNameLabel => 'display name…';

  @override
  String get authExpiredTitle => 'Sign-in required';

  @override
  String get authExpiredBody =>
      'The server rejected the request: the token is missing, invalid, or revoked. Update the connection token and try again.';

  @override
  String get signInAgain => 'Sign in again';

  @override
  String get defaultModel => 'Default model';

  @override
  String get defaultPreset => 'Default preset';

  @override
  String get sessionGroupLabel => 'Group';

  @override
  String get subsessionBadge => 'Subsession';

  @override
  String subsessionCount(Object count) {
    return '$count subsessions';
  }

  @override
  String get mailboxPrompt => 'Message';

  @override
  String get mailboxFromSession => 'From session';

  @override
  String get mailboxFromSystem => 'From system';

  @override
  String get mailboxInterrupt => 'Interrupt';

  @override
  String get mailboxEvent => 'Event';

  @override
  String get deliver => 'Deliver to mailbox';

  @override
  String get sending => 'Sending…';

  @override
  String get noMoreMessages => 'No more messages';

  @override
  String get forked => 'Forked';
}
