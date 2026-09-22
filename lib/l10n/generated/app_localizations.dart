import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In zh, this message translates to:
  /// **'Easy Agent'**
  String get appTitle;

  /// No description provided for @gatewayUrl.
  ///
  /// In zh, this message translates to:
  /// **'网关地址'**
  String get gatewayUrl;

  /// No description provided for @tokenLabel.
  ///
  /// In zh, this message translates to:
  /// **'令牌'**
  String get tokenLabel;

  /// No description provided for @connect.
  ///
  /// In zh, this message translates to:
  /// **'连接'**
  String get connect;

  /// No description provided for @connecting.
  ///
  /// In zh, this message translates to:
  /// **'连接中…'**
  String get connecting;

  /// No description provided for @search.
  ///
  /// In zh, this message translates to:
  /// **'搜索'**
  String get search;

  /// No description provided for @searchHint.
  ///
  /// In zh, this message translates to:
  /// **'搜索会话名称'**
  String get searchHint;

  /// No description provided for @recent.
  ///
  /// In zh, this message translates to:
  /// **'最近'**
  String get recent;

  /// No description provided for @me.
  ///
  /// In zh, this message translates to:
  /// **'我'**
  String get me;

  /// No description provided for @tabChat.
  ///
  /// In zh, this message translates to:
  /// **'会话'**
  String get tabChat;

  /// No description provided for @tabConfig.
  ///
  /// In zh, this message translates to:
  /// **'设置'**
  String get tabConfig;

  /// No description provided for @loadError.
  ///
  /// In zh, this message translates to:
  /// **'加载失败：{arg1}'**
  String loadError(String arg1);

  /// No description provided for @markRead.
  ///
  /// In zh, this message translates to:
  /// **'标记已读'**
  String get markRead;

  /// No description provided for @typeMessage.
  ///
  /// In zh, this message translates to:
  /// **'输入消息…'**
  String get typeMessage;

  /// No description provided for @chatTitle.
  ///
  /// In zh, this message translates to:
  /// **'会话'**
  String get chatTitle;

  /// No description provided for @thinkLabel.
  ///
  /// In zh, this message translates to:
  /// **'思考'**
  String get thinkLabel;

  /// No description provided for @compactedLabel.
  ///
  /// In zh, this message translates to:
  /// **'历史已压缩 · 查看摘要'**
  String get compactedLabel;

  /// No description provided for @copied.
  ///
  /// In zh, this message translates to:
  /// **'已复制'**
  String get copied;

  /// No description provided for @copy.
  ///
  /// In zh, this message translates to:
  /// **'复制'**
  String get copy;

  /// No description provided for @error.
  ///
  /// In zh, this message translates to:
  /// **'错误'**
  String get error;

  /// No description provided for @undo.
  ///
  /// In zh, this message translates to:
  /// **'撤销'**
  String get undo;

  /// No description provided for @retry.
  ///
  /// In zh, this message translates to:
  /// **'重试'**
  String get retry;

  /// No description provided for @editMessage.
  ///
  /// In zh, this message translates to:
  /// **'编辑消息'**
  String get editMessage;

  /// No description provided for @undoTitle.
  ///
  /// In zh, this message translates to:
  /// **'撤销此消息？'**
  String get undoTitle;

  /// No description provided for @undoBody.
  ///
  /// In zh, this message translates to:
  /// **'将删除该消息，并撤销之后的所有消息。'**
  String get undoBody;

  /// No description provided for @retryTitle.
  ///
  /// In zh, this message translates to:
  /// **'重发此消息？'**
  String get retryTitle;

  /// No description provided for @retryBody.
  ///
  /// In zh, this message translates to:
  /// **'将撤销该消息及其之后的所有消息，并以原文重新发送。'**
  String get retryBody;

  /// No description provided for @cancel.
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get cancel;

  /// No description provided for @apply.
  ///
  /// In zh, this message translates to:
  /// **'应用'**
  String get apply;

  /// No description provided for @delete.
  ///
  /// In zh, this message translates to:
  /// **'删除'**
  String get delete;

  /// No description provided for @loading.
  ///
  /// In zh, this message translates to:
  /// **'加载中…'**
  String get loading;

  /// No description provided for @loadEarlier.
  ///
  /// In zh, this message translates to:
  /// **'加载更早的消息'**
  String get loadEarlier;

  /// No description provided for @thinking.
  ///
  /// In zh, this message translates to:
  /// **'思考中…'**
  String get thinking;

  /// No description provided for @running.
  ///
  /// In zh, this message translates to:
  /// **'运行中…'**
  String get running;

  /// No description provided for @sendFailed.
  ///
  /// In zh, this message translates to:
  /// **'发送失败: {arg1}'**
  String sendFailed(String arg1);

  /// No description provided for @send.
  ///
  /// In zh, this message translates to:
  /// **'发送'**
  String get send;

  /// No description provided for @attach.
  ///
  /// In zh, this message translates to:
  /// **'添加附件'**
  String get attach;

  /// No description provided for @dropToAttach.
  ///
  /// In zh, this message translates to:
  /// **'松开以添加为附件'**
  String get dropToAttach;

  /// No description provided for @followSystem.
  ///
  /// In zh, this message translates to:
  /// **'跟随系统'**
  String get followSystem;

  /// No description provided for @themeLight.
  ///
  /// In zh, this message translates to:
  /// **'浅色'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In zh, this message translates to:
  /// **'深色'**
  String get themeDark;

  /// No description provided for @folderNotAllowed.
  ///
  /// In zh, this message translates to:
  /// **'不支持拖入文件夹——请拖入单个文件'**
  String get folderNotAllowed;

  /// No description provided for @image.
  ///
  /// In zh, this message translates to:
  /// **'图片'**
  String get image;

  /// No description provided for @takePhoto.
  ///
  /// In zh, this message translates to:
  /// **'拍照'**
  String get takePhoto;

  /// No description provided for @chooseImage.
  ///
  /// In zh, this message translates to:
  /// **'从相册选图'**
  String get chooseImage;

  /// No description provided for @chooseFile.
  ///
  /// In zh, this message translates to:
  /// **'选择文件'**
  String get chooseFile;

  /// No description provided for @uploadFailedRetry.
  ///
  /// In zh, this message translates to:
  /// **'{arg1} 个附件上传失败——请重试或移除后再发送'**
  String uploadFailedRetry(String arg1);

  /// No description provided for @compactHistory.
  ///
  /// In zh, this message translates to:
  /// **'压缩历史'**
  String get compactHistory;

  /// No description provided for @mailbox.
  ///
  /// In zh, this message translates to:
  /// **'收件箱'**
  String get mailbox;

  /// No description provided for @container.
  ///
  /// In zh, this message translates to:
  /// **'容器'**
  String get container;

  /// No description provided for @deleteSession.
  ///
  /// In zh, this message translates to:
  /// **'删除会话'**
  String get deleteSession;

  /// No description provided for @historyCompacted.
  ///
  /// In zh, this message translates to:
  /// **'历史已压缩'**
  String get historyCompacted;

  /// No description provided for @nothingToCompact.
  ///
  /// In zh, this message translates to:
  /// **'历史太短，无需压缩'**
  String get nothingToCompact;

  /// No description provided for @back.
  ///
  /// In zh, this message translates to:
  /// **'返回'**
  String get back;

  /// No description provided for @refresh.
  ///
  /// In zh, this message translates to:
  /// **'刷新'**
  String get refresh;

  /// No description provided for @taskDone.
  ///
  /// In zh, this message translates to:
  /// **'已完成'**
  String get taskDone;

  /// No description provided for @settingsTitle.
  ///
  /// In zh, this message translates to:
  /// **'会话设置'**
  String get settingsTitle;

  /// No description provided for @modelLabel.
  ///
  /// In zh, this message translates to:
  /// **'模型'**
  String get modelLabel;

  /// No description provided for @variantLabel.
  ///
  /// In zh, this message translates to:
  /// **'推理档位'**
  String get variantLabel;

  /// No description provided for @variantNone.
  ///
  /// In zh, this message translates to:
  /// **'默认（不指定档位）'**
  String get variantNone;

  /// No description provided for @presetLabel.
  ///
  /// In zh, this message translates to:
  /// **'预设'**
  String get presetLabel;

  /// No description provided for @deleteSessionTitle.
  ///
  /// In zh, this message translates to:
  /// **'删除会话'**
  String get deleteSessionTitle;

  /// No description provided for @deleteSessionBody.
  ///
  /// In zh, this message translates to:
  /// **'删除会话\"{arg1}\"？'**
  String deleteSessionBody(String arg1);

  /// No description provided for @deleteSessionsTitle.
  ///
  /// In zh, this message translates to:
  /// **'删除会话'**
  String get deleteSessionsTitle;

  /// No description provided for @deleteSessionsBody.
  ///
  /// In zh, this message translates to:
  /// **'删除选中的 {arg1} 个会话？此操作不可撤销。'**
  String deleteSessionsBody(String arg1);

  /// No description provided for @selectSessions.
  ///
  /// In zh, this message translates to:
  /// **'选择'**
  String get selectSessions;

  /// No description provided for @selectAll.
  ///
  /// In zh, this message translates to:
  /// **'全选'**
  String get selectAll;

  /// No description provided for @selectedCount.
  ///
  /// In zh, this message translates to:
  /// **'已选 {arg1} 项'**
  String selectedCount(String arg1);

  /// No description provided for @addModel.
  ///
  /// In zh, this message translates to:
  /// **'添加模型'**
  String get addModel;

  /// No description provided for @holdToTalk.
  ///
  /// In zh, this message translates to:
  /// **'按住说话'**
  String get holdToTalk;

  /// No description provided for @releaseToSend.
  ///
  /// In zh, this message translates to:
  /// **'松开发送'**
  String get releaseToSend;

  /// No description provided for @abort.
  ///
  /// In zh, this message translates to:
  /// **'中止'**
  String get abort;

  /// No description provided for @edit.
  ///
  /// In zh, this message translates to:
  /// **'编辑'**
  String get edit;

  /// No description provided for @voiceMode.
  ///
  /// In zh, this message translates to:
  /// **'语音'**
  String get voiceMode;

  /// No description provided for @keyboardMode.
  ///
  /// In zh, this message translates to:
  /// **'键盘'**
  String get keyboardMode;

  /// No description provided for @voicePermission.
  ///
  /// In zh, this message translates to:
  /// **'未获得麦克风权限'**
  String get voicePermission;

  /// No description provided for @voiceTooShort.
  ///
  /// In zh, this message translates to:
  /// **'录音太短'**
  String get voiceTooShort;

  /// No description provided for @uploading.
  ///
  /// In zh, this message translates to:
  /// **'上传中…'**
  String get uploading;

  /// No description provided for @uploadFailed.
  ///
  /// In zh, this message translates to:
  /// **'上传失败'**
  String get uploadFailed;

  /// No description provided for @capText.
  ///
  /// In zh, this message translates to:
  /// **'文本'**
  String get capText;

  /// No description provided for @capImage.
  ///
  /// In zh, this message translates to:
  /// **'图像'**
  String get capImage;

  /// No description provided for @capVideo.
  ///
  /// In zh, this message translates to:
  /// **'视频'**
  String get capVideo;

  /// No description provided for @capSpeech.
  ///
  /// In zh, this message translates to:
  /// **'语音'**
  String get capSpeech;

  /// No description provided for @capTranscription.
  ///
  /// In zh, this message translates to:
  /// **'转写'**
  String get capTranscription;

  /// No description provided for @capEmbedding.
  ///
  /// In zh, this message translates to:
  /// **'向量'**
  String get capEmbedding;

  /// No description provided for @capReranking.
  ///
  /// In zh, this message translates to:
  /// **'重排'**
  String get capReranking;

  /// No description provided for @capRealtime.
  ///
  /// In zh, this message translates to:
  /// **'实时'**
  String get capRealtime;

  /// No description provided for @fork.
  ///
  /// In zh, this message translates to:
  /// **'分叉'**
  String get fork;

  /// No description provided for @failed.
  ///
  /// In zh, this message translates to:
  /// **'失败: {arg1}'**
  String failed(String arg1);

  /// No description provided for @settings.
  ///
  /// In zh, this message translates to:
  /// **'设置'**
  String get settings;

  /// No description provided for @appearance.
  ///
  /// In zh, this message translates to:
  /// **'外观'**
  String get appearance;

  /// No description provided for @darkMode.
  ///
  /// In zh, this message translates to:
  /// **'深色模式'**
  String get darkMode;

  /// No description provided for @llm.
  ///
  /// In zh, this message translates to:
  /// **'语言模型'**
  String get llm;

  /// No description provided for @llmProviders.
  ///
  /// In zh, this message translates to:
  /// **'供应商'**
  String get llmProviders;

  /// No description provided for @providers.
  ///
  /// In zh, this message translates to:
  /// **'供应商'**
  String get providers;

  /// No description provided for @presets.
  ///
  /// In zh, this message translates to:
  /// **'预设'**
  String get presets;

  /// No description provided for @workspace.
  ///
  /// In zh, this message translates to:
  /// **'工作区'**
  String get workspace;

  /// No description provided for @tools.
  ///
  /// In zh, this message translates to:
  /// **'工具'**
  String get tools;

  /// No description provided for @language.
  ///
  /// In zh, this message translates to:
  /// **'语言'**
  String get language;

  /// No description provided for @switchBackend.
  ///
  /// In zh, this message translates to:
  /// **'切换用户'**
  String get switchBackend;

  /// No description provided for @backendsTitle.
  ///
  /// In zh, this message translates to:
  /// **'用户'**
  String get backendsTitle;

  /// No description provided for @noSavedBackends.
  ///
  /// In zh, this message translates to:
  /// **'暂无已保存的用户。'**
  String get noSavedBackends;

  /// No description provided for @addBackend.
  ///
  /// In zh, this message translates to:
  /// **'添加新用户'**
  String get addBackend;

  /// No description provided for @addBackendHint.
  ///
  /// In zh, this message translates to:
  /// **'使用其它地址与令牌登录'**
  String get addBackendHint;

  /// No description provided for @deleteBackend.
  ///
  /// In zh, this message translates to:
  /// **'移除用户'**
  String get deleteBackend;

  /// No description provided for @backendSection.
  ///
  /// In zh, this message translates to:
  /// **'后端'**
  String get backendSection;

  /// No description provided for @providerTemplate.
  ///
  /// In zh, this message translates to:
  /// **'模板（models.dev）'**
  String get providerTemplate;

  /// No description provided for @providerTemplateHint.
  ///
  /// In zh, this message translates to:
  /// **'选择服务商自动填充'**
  String get providerTemplateHint;

  /// No description provided for @searchModels.
  ///
  /// In zh, this message translates to:
  /// **'搜索模型…'**
  String get searchModels;

  /// No description provided for @noProviders.
  ///
  /// In zh, this message translates to:
  /// **'暂无供应商，添加一个开始使用。'**
  String get noProviders;

  /// No description provided for @addProvider.
  ///
  /// In zh, this message translates to:
  /// **'添加供应商'**
  String get addProvider;

  /// No description provided for @modelsCount.
  ///
  /// In zh, this message translates to:
  /// **'{arg1} 个模型'**
  String modelsCount(String arg1);

  /// No description provided for @providerId.
  ///
  /// In zh, this message translates to:
  /// **'供应商 ID'**
  String get providerId;

  /// No description provided for @providerIdReq.
  ///
  /// In zh, this message translates to:
  /// **'供应商 ID（必填）'**
  String get providerIdReq;

  /// No description provided for @apiType.
  ///
  /// In zh, this message translates to:
  /// **'API 类型'**
  String get apiType;

  /// No description provided for @apiTypeOpenai.
  ///
  /// In zh, this message translates to:
  /// **'OpenAI'**
  String get apiTypeOpenai;

  /// No description provided for @apiTypeAnthropic.
  ///
  /// In zh, this message translates to:
  /// **'Anthropic'**
  String get apiTypeAnthropic;

  /// No description provided for @apiTypeGemini.
  ///
  /// In zh, this message translates to:
  /// **'Gemini'**
  String get apiTypeGemini;

  /// No description provided for @baseUrl.
  ///
  /// In zh, this message translates to:
  /// **'基础地址'**
  String get baseUrl;

  /// No description provided for @apiKey.
  ///
  /// In zh, this message translates to:
  /// **'API 密钥'**
  String get apiKey;

  /// No description provided for @test.
  ///
  /// In zh, this message translates to:
  /// **'测试'**
  String get test;

  /// No description provided for @testing.
  ///
  /// In zh, this message translates to:
  /// **'测试中…'**
  String get testing;

  /// No description provided for @register.
  ///
  /// In zh, this message translates to:
  /// **'注册'**
  String get register;

  /// No description provided for @registering.
  ///
  /// In zh, this message translates to:
  /// **'注册中…'**
  String get registering;

  /// No description provided for @saved.
  ///
  /// In zh, this message translates to:
  /// **'已保存'**
  String get saved;

  /// No description provided for @noConfig.
  ///
  /// In zh, this message translates to:
  /// **'无配置'**
  String get noConfig;

  /// No description provided for @configured.
  ///
  /// In zh, this message translates to:
  /// **'已配置'**
  String get configured;

  /// No description provided for @needsConfig.
  ///
  /// In zh, this message translates to:
  /// **'需配置'**
  String get needsConfig;

  /// No description provided for @newPreset.
  ///
  /// In zh, this message translates to:
  /// **'新建预设'**
  String get newPreset;

  /// No description provided for @presetId.
  ///
  /// In zh, this message translates to:
  /// **'预设 ID…'**
  String get presetId;

  /// No description provided for @create.
  ///
  /// In zh, this message translates to:
  /// **'创建'**
  String get create;

  /// No description provided for @noPresets.
  ///
  /// In zh, this message translates to:
  /// **'暂无预设。'**
  String get noPresets;

  /// No description provided for @deletePreset.
  ///
  /// In zh, this message translates to:
  /// **'删除预设'**
  String get deletePreset;

  /// No description provided for @deletePresetBody.
  ///
  /// In zh, this message translates to:
  /// **'删除预设 {arg1}？'**
  String deletePresetBody(String arg1);

  /// No description provided for @presetSummary.
  ///
  /// In zh, this message translates to:
  /// **'最大 {arg1} 轮 · {arg2} 个工具'**
  String presetSummary(String arg1, String arg2);

  /// No description provided for @systemPrompt.
  ///
  /// In zh, this message translates to:
  /// **'系统提示'**
  String get systemPrompt;

  /// No description provided for @maxTurns.
  ///
  /// In zh, this message translates to:
  /// **'最大轮数'**
  String get maxTurns;

  /// No description provided for @terminal.
  ///
  /// In zh, this message translates to:
  /// **'终端'**
  String get terminal;

  /// No description provided for @close.
  ///
  /// In zh, this message translates to:
  /// **'关闭'**
  String get close;

  /// No description provided for @noSession.
  ///
  /// In zh, this message translates to:
  /// **'无会话'**
  String get noSession;

  /// No description provided for @history.
  ///
  /// In zh, this message translates to:
  /// **'历史'**
  String get history;

  /// No description provided for @none.
  ///
  /// In zh, this message translates to:
  /// **'无'**
  String get none;

  /// No description provided for @download.
  ///
  /// In zh, this message translates to:
  /// **'下载'**
  String get download;

  /// No description provided for @noMessages.
  ///
  /// In zh, this message translates to:
  /// **'暂无消息'**
  String get noMessages;

  /// No description provided for @consumed.
  ///
  /// In zh, this message translates to:
  /// **'已消费'**
  String get consumed;

  /// No description provided for @pending.
  ///
  /// In zh, this message translates to:
  /// **'待审批'**
  String get pending;

  /// No description provided for @savedToDownloads.
  ///
  /// In zh, this message translates to:
  /// **'已保存到「下载」：{arg1}'**
  String savedToDownloads(String arg1);

  /// No description provided for @timeJustNow.
  ///
  /// In zh, this message translates to:
  /// **'刚刚'**
  String get timeJustNow;

  /// No description provided for @timeMinAgo.
  ///
  /// In zh, this message translates to:
  /// **'{arg1} 分钟前'**
  String timeMinAgo(String arg1);

  /// No description provided for @timeHour.
  ///
  /// In zh, this message translates to:
  /// **'{arg1} 小时前'**
  String timeHour(String arg1);

  /// No description provided for @timeDay.
  ///
  /// In zh, this message translates to:
  /// **'{arg1} 天前'**
  String timeDay(String arg1);

  /// No description provided for @baseUrlReq.
  ///
  /// In zh, this message translates to:
  /// **'基础地址（必填）'**
  String get baseUrlReq;

  /// No description provided for @apiKeyReq.
  ///
  /// In zh, this message translates to:
  /// **'API 密钥（必填）'**
  String get apiKeyReq;

  /// No description provided for @save.
  ///
  /// In zh, this message translates to:
  /// **'保存'**
  String get save;

  /// No description provided for @noTools.
  ///
  /// In zh, this message translates to:
  /// **'暂无工具'**
  String get noTools;

  /// No description provided for @agentLocale.
  ///
  /// In zh, this message translates to:
  /// **'Agent 语言'**
  String get agentLocale;

  /// No description provided for @agentLocaleFollow.
  ///
  /// In zh, this message translates to:
  /// **'跟随（UI 语言）'**
  String get agentLocaleFollow;

  /// No description provided for @agentLocaleApplied.
  ///
  /// In zh, this message translates to:
  /// **'Agent 语言已切换为 {l}'**
  String agentLocaleApplied(String l);

  /// No description provided for @toolParams.
  ///
  /// In zh, this message translates to:
  /// **'参数'**
  String get toolParams;

  /// No description provided for @showMore.
  ///
  /// In zh, this message translates to:
  /// **'展开'**
  String get showMore;

  /// No description provided for @showLess.
  ///
  /// In zh, this message translates to:
  /// **'收起'**
  String get showLess;

  /// No description provided for @systemPresetBadge.
  ///
  /// In zh, this message translates to:
  /// **'系统'**
  String get systemPresetBadge;

  /// No description provided for @readOnlyPreset.
  ///
  /// In zh, this message translates to:
  /// **'系统预设：只读，不可编辑'**
  String get readOnlyPreset;

  /// No description provided for @sysPromptByPreset.
  ///
  /// In zh, this message translates to:
  /// **'系统提示由所选预设决定，不可直接修改。'**
  String get sysPromptByPreset;

  /// No description provided for @requiredConfig.
  ///
  /// In zh, this message translates to:
  /// **'必需配置'**
  String get requiredConfig;

  /// No description provided for @selectProviderFirst.
  ///
  /// In zh, this message translates to:
  /// **'请先选择服务商'**
  String get selectProviderFirst;

  /// No description provided for @apiTypeOpenaiCompat.
  ///
  /// In zh, this message translates to:
  /// **'OpenAI 兼容'**
  String get apiTypeOpenaiCompat;

  /// No description provided for @modelsLabel.
  ///
  /// In zh, this message translates to:
  /// **'模型'**
  String get modelsLabel;

  /// No description provided for @modelIdLabel.
  ///
  /// In zh, this message translates to:
  /// **'模型 ID…'**
  String get modelIdLabel;

  /// No description provided for @contextLengthLabel.
  ///
  /// In zh, this message translates to:
  /// **'上下文'**
  String get contextLengthLabel;

  /// No description provided for @contextLengthRequired.
  ///
  /// In zh, this message translates to:
  /// **'必须填写上下文长度（正整数）。'**
  String get contextLengthRequired;

  /// No description provided for @add.
  ///
  /// In zh, this message translates to:
  /// **'添加'**
  String get add;

  /// No description provided for @turnsByPreset.
  ///
  /// In zh, this message translates to:
  /// **'最大轮数由所选预设决定。'**
  String get turnsByPreset;

  /// No description provided for @testModelOk.
  ///
  /// In zh, this message translates to:
  /// **'模型可用：{arg1}'**
  String testModelOk(Object arg1);

  /// No description provided for @connectionError.
  ///
  /// In zh, this message translates to:
  /// **'连接错误：{arg1}'**
  String connectionError(Object arg1);

  /// No description provided for @toolInputParams.
  ///
  /// In zh, this message translates to:
  /// **'输入参数'**
  String get toolInputParams;

  /// No description provided for @content.
  ///
  /// In zh, this message translates to:
  /// **'内容'**
  String get content;

  /// No description provided for @metadata.
  ///
  /// In zh, this message translates to:
  /// **'元数据'**
  String get metadata;

  /// No description provided for @newSession.
  ///
  /// In zh, this message translates to:
  /// **'新会话'**
  String get newSession;

  /// No description provided for @noSessions.
  ///
  /// In zh, this message translates to:
  /// **'暂无会话'**
  String get noSessions;

  /// No description provided for @apiTypeGateway.
  ///
  /// In zh, this message translates to:
  /// **'Vercel AI 网关'**
  String get apiTypeGateway;

  /// No description provided for @apiTypeDeepseek.
  ///
  /// In zh, this message translates to:
  /// **'DeepSeek'**
  String get apiTypeDeepseek;

  /// No description provided for @apiTypeCohere.
  ///
  /// In zh, this message translates to:
  /// **'Cohere'**
  String get apiTypeCohere;

  /// No description provided for @capabilityLabel.
  ///
  /// In zh, this message translates to:
  /// **'模态'**
  String get capabilityLabel;

  /// No description provided for @nonTextModelHint.
  ///
  /// In zh, this message translates to:
  /// **'非文本模型供工具调用，无需上下文窗口。'**
  String get nonTextModelHint;

  /// No description provided for @modelNameLabel.
  ///
  /// In zh, this message translates to:
  /// **'显示名称…'**
  String get modelNameLabel;

  /// No description provided for @authExpiredTitle.
  ///
  /// In zh, this message translates to:
  /// **'认证失败'**
  String get authExpiredTitle;

  /// No description provided for @authExpiredBody.
  ///
  /// In zh, this message translates to:
  /// **'服务器拒绝了请求：令牌缺失、无效或已被吊销。请在连接设置中更新令牌后重试。'**
  String get authExpiredBody;

  /// No description provided for @signInAgain.
  ///
  /// In zh, this message translates to:
  /// **'重新登录'**
  String get signInAgain;

  /// No description provided for @defaultModel.
  ///
  /// In zh, this message translates to:
  /// **'默认模型'**
  String get defaultModel;

  /// No description provided for @defaultPreset.
  ///
  /// In zh, this message translates to:
  /// **'默认预设'**
  String get defaultPreset;

  /// No description provided for @sessionGroupLabel.
  ///
  /// In zh, this message translates to:
  /// **'分组'**
  String get sessionGroupLabel;

  /// No description provided for @subsessionBadge.
  ///
  /// In zh, this message translates to:
  /// **'子会话'**
  String get subsessionBadge;

  /// No description provided for @subsessionCount.
  ///
  /// In zh, this message translates to:
  /// **'{count} 个子会话'**
  String subsessionCount(Object count);

  /// No description provided for @mailboxPrompt.
  ///
  /// In zh, this message translates to:
  /// **'消息'**
  String get mailboxPrompt;

  /// No description provided for @mailboxFromSession.
  ///
  /// In zh, this message translates to:
  /// **'来自会话'**
  String get mailboxFromSession;

  /// No description provided for @mailboxFromSystem.
  ///
  /// In zh, this message translates to:
  /// **'来自系统'**
  String get mailboxFromSystem;

  /// No description provided for @mailboxInterrupt.
  ///
  /// In zh, this message translates to:
  /// **'中断'**
  String get mailboxInterrupt;

  /// No description provided for @mailboxEvent.
  ///
  /// In zh, this message translates to:
  /// **'事件'**
  String get mailboxEvent;

  /// No description provided for @deliver.
  ///
  /// In zh, this message translates to:
  /// **'发送到信箱'**
  String get deliver;

  /// No description provided for @sending.
  ///
  /// In zh, this message translates to:
  /// **'发送中…'**
  String get sending;

  /// No description provided for @noMoreMessages.
  ///
  /// In zh, this message translates to:
  /// **'没有更多消息'**
  String get noMoreMessages;

  /// No description provided for @forked.
  ///
  /// In zh, this message translates to:
  /// **'已派生'**
  String get forked;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
