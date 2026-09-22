// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Easy Agent';

  @override
  String get gatewayUrl => '网关地址';

  @override
  String get tokenLabel => '令牌';

  @override
  String get connect => '连接';

  @override
  String get connecting => '连接中…';

  @override
  String get search => '搜索';

  @override
  String get searchHint => '搜索会话名称';

  @override
  String get recent => '最近';

  @override
  String get me => '我';

  @override
  String get tabChat => '会话';

  @override
  String get tabConfig => '设置';

  @override
  String loadError(String arg1) {
    return '加载失败：$arg1';
  }

  @override
  String get markRead => '标记已读';

  @override
  String get typeMessage => '输入消息…';

  @override
  String get chatTitle => '会话';

  @override
  String get thinkLabel => '思考';

  @override
  String get compactedLabel => '历史已压缩 · 查看摘要';

  @override
  String get copied => '已复制';

  @override
  String get copy => '复制';

  @override
  String get error => '错误';

  @override
  String get undo => '撤销';

  @override
  String get retry => '重试';

  @override
  String get editMessage => '编辑消息';

  @override
  String get undoTitle => '撤销此消息？';

  @override
  String get undoBody => '将删除该消息，并撤销之后的所有消息。';

  @override
  String get retryTitle => '重发此消息？';

  @override
  String get retryBody => '将撤销该消息及其之后的所有消息，并以原文重新发送。';

  @override
  String get cancel => '取消';

  @override
  String get apply => '应用';

  @override
  String get delete => '删除';

  @override
  String get loading => '加载中…';

  @override
  String get loadEarlier => '加载更早的消息';

  @override
  String get thinking => '思考中…';

  @override
  String get running => '运行中…';

  @override
  String sendFailed(String arg1) {
    return '发送失败: $arg1';
  }

  @override
  String get send => '发送';

  @override
  String get attach => '添加附件';

  @override
  String get dropToAttach => '松开以添加为附件';

  @override
  String get followSystem => '跟随系统';

  @override
  String get themeLight => '浅色';

  @override
  String get themeDark => '深色';

  @override
  String get folderNotAllowed => '不支持拖入文件夹——请拖入单个文件';

  @override
  String get image => '图片';

  @override
  String get takePhoto => '拍照';

  @override
  String get chooseImage => '从相册选图';

  @override
  String get chooseFile => '选择文件';

  @override
  String uploadFailedRetry(String arg1) {
    return '$arg1 个附件上传失败——请重试或移除后再发送';
  }

  @override
  String get compactHistory => '压缩历史';

  @override
  String get mailbox => '收件箱';

  @override
  String get container => '容器';

  @override
  String get deleteSession => '删除会话';

  @override
  String get historyCompacted => '历史已压缩';

  @override
  String get nothingToCompact => '历史太短，无需压缩';

  @override
  String get back => '返回';

  @override
  String get refresh => '刷新';

  @override
  String get taskDone => '已完成';

  @override
  String get settingsTitle => '会话设置';

  @override
  String get modelLabel => '模型';

  @override
  String get variantLabel => '推理档位';

  @override
  String get variantNone => '默认（不指定档位）';

  @override
  String get presetLabel => '预设';

  @override
  String get deleteSessionTitle => '删除会话';

  @override
  String deleteSessionBody(String arg1) {
    return '删除会话\"$arg1\"？';
  }

  @override
  String get deleteSessionsTitle => '删除会话';

  @override
  String deleteSessionsBody(String arg1) {
    return '删除选中的 $arg1 个会话？此操作不可撤销。';
  }

  @override
  String get selectSessions => '选择';

  @override
  String get selectAll => '全选';

  @override
  String selectedCount(String arg1) {
    return '已选 $arg1 项';
  }

  @override
  String get addModel => '添加模型';

  @override
  String get holdToTalk => '按住说话';

  @override
  String get releaseToSend => '松开发送';

  @override
  String get abort => '中止';

  @override
  String get edit => '编辑';

  @override
  String get voiceMode => '语音';

  @override
  String get keyboardMode => '键盘';

  @override
  String get voicePermission => '未获得麦克风权限';

  @override
  String get voiceTooShort => '录音太短';

  @override
  String get uploading => '上传中…';

  @override
  String get uploadFailed => '上传失败';

  @override
  String get capText => '文本';

  @override
  String get capImage => '图像';

  @override
  String get capVideo => '视频';

  @override
  String get capSpeech => '语音';

  @override
  String get capTranscription => '转写';

  @override
  String get capEmbedding => '向量';

  @override
  String get capReranking => '重排';

  @override
  String get capRealtime => '实时';

  @override
  String get fork => '分叉';

  @override
  String failed(String arg1) {
    return '失败: $arg1';
  }

  @override
  String get settings => '设置';

  @override
  String get appearance => '外观';

  @override
  String get darkMode => '深色模式';

  @override
  String get llm => '语言模型';

  @override
  String get llmProviders => '供应商';

  @override
  String get providers => '供应商';

  @override
  String get presets => '预设';

  @override
  String get workspace => '工作区';

  @override
  String get tools => '工具';

  @override
  String get language => '语言';

  @override
  String get switchBackend => '切换用户';

  @override
  String get backendsTitle => '用户';

  @override
  String get noSavedBackends => '暂无已保存的用户。';

  @override
  String get addBackend => '添加新用户';

  @override
  String get addBackendHint => '使用其它地址与令牌登录';

  @override
  String get deleteBackend => '移除用户';

  @override
  String get backendSection => '后端';

  @override
  String get providerTemplate => '模板（models.dev）';

  @override
  String get providerTemplateHint => '选择服务商自动填充';

  @override
  String get searchModels => '搜索模型…';

  @override
  String get noProviders => '暂无供应商，添加一个开始使用。';

  @override
  String get addProvider => '添加供应商';

  @override
  String modelsCount(String arg1) {
    return '$arg1 个模型';
  }

  @override
  String get providerId => '供应商 ID';

  @override
  String get providerIdReq => '供应商 ID（必填）';

  @override
  String get apiType => 'API 类型';

  @override
  String get apiTypeOpenai => 'OpenAI';

  @override
  String get apiTypeAnthropic => 'Anthropic';

  @override
  String get apiTypeGemini => 'Gemini';

  @override
  String get baseUrl => '基础地址';

  @override
  String get apiKey => 'API 密钥';

  @override
  String get test => '测试';

  @override
  String get testing => '测试中…';

  @override
  String get register => '注册';

  @override
  String get registering => '注册中…';

  @override
  String get saved => '已保存';

  @override
  String get noConfig => '无配置';

  @override
  String get configured => '已配置';

  @override
  String get needsConfig => '需配置';

  @override
  String get newPreset => '新建预设';

  @override
  String get presetId => '预设 ID…';

  @override
  String get create => '创建';

  @override
  String get noPresets => '暂无预设。';

  @override
  String get deletePreset => '删除预设';

  @override
  String deletePresetBody(String arg1) {
    return '删除预设 $arg1？';
  }

  @override
  String presetSummary(String arg1, String arg2) {
    return '最大 $arg1 轮 · $arg2 个工具';
  }

  @override
  String get systemPrompt => '系统提示';

  @override
  String get maxTurns => '最大轮数';

  @override
  String get terminal => '终端';

  @override
  String get close => '关闭';

  @override
  String get noSession => '无会话';

  @override
  String get history => '历史';

  @override
  String get none => '无';

  @override
  String get download => '下载';

  @override
  String get noMessages => '暂无消息';

  @override
  String get consumed => '已消费';

  @override
  String get pending => '待审批';

  @override
  String savedToDownloads(String arg1) {
    return '已保存到「下载」：$arg1';
  }

  @override
  String get timeJustNow => '刚刚';

  @override
  String timeMinAgo(String arg1) {
    return '$arg1 分钟前';
  }

  @override
  String timeHour(String arg1) {
    return '$arg1 小时前';
  }

  @override
  String timeDay(String arg1) {
    return '$arg1 天前';
  }

  @override
  String get baseUrlReq => '基础地址（必填）';

  @override
  String get apiKeyReq => 'API 密钥（必填）';

  @override
  String get save => '保存';

  @override
  String get noTools => '暂无工具';

  @override
  String get agentLocale => 'Agent 语言';

  @override
  String get agentLocaleFollow => '跟随（UI 语言）';

  @override
  String agentLocaleApplied(String l) {
    return 'Agent 语言已切换为 $l';
  }

  @override
  String get toolParams => '参数';

  @override
  String get showMore => '展开';

  @override
  String get showLess => '收起';

  @override
  String get systemPresetBadge => '系统';

  @override
  String get readOnlyPreset => '系统预设：只读，不可编辑';

  @override
  String get sysPromptByPreset => '系统提示由所选预设决定，不可直接修改。';

  @override
  String get requiredConfig => '必需配置';

  @override
  String get selectProviderFirst => '请先选择服务商';

  @override
  String get apiTypeOpenaiCompat => 'OpenAI 兼容';

  @override
  String get modelsLabel => '模型';

  @override
  String get modelIdLabel => '模型 ID…';

  @override
  String get contextLengthLabel => '上下文';

  @override
  String get contextLengthRequired => '必须填写上下文长度（正整数）。';

  @override
  String get add => '添加';

  @override
  String get turnsByPreset => '最大轮数由所选预设决定。';

  @override
  String testModelOk(Object arg1) {
    return '模型可用：$arg1';
  }

  @override
  String connectionError(Object arg1) {
    return '连接错误：$arg1';
  }

  @override
  String get toolInputParams => '输入参数';

  @override
  String get content => '内容';

  @override
  String get metadata => '元数据';

  @override
  String get newSession => '新会话';

  @override
  String get noSessions => '暂无会话';

  @override
  String get apiTypeGateway => 'Vercel AI 网关';

  @override
  String get apiTypeDeepseek => 'DeepSeek';

  @override
  String get apiTypeCohere => 'Cohere';

  @override
  String get capabilityLabel => '模态';

  @override
  String get nonTextModelHint => '非文本模型供工具调用，无需上下文窗口。';

  @override
  String get modelNameLabel => '显示名称…';

  @override
  String get authExpiredTitle => '认证失败';

  @override
  String get authExpiredBody => '服务器拒绝了请求：令牌缺失、无效或已被吊销。请在连接设置中更新令牌后重试。';

  @override
  String get signInAgain => '重新登录';

  @override
  String get defaultModel => '默认模型';

  @override
  String get defaultPreset => '默认预设';

  @override
  String get sessionGroupLabel => '分组';

  @override
  String get subsessionBadge => '子会话';

  @override
  String subsessionCount(Object count) {
    return '$count 个子会话';
  }

  @override
  String get mailboxPrompt => '消息';

  @override
  String get mailboxFromSession => '来自会话';

  @override
  String get mailboxFromSystem => '来自系统';

  @override
  String get mailboxInterrupt => '中断';

  @override
  String get mailboxEvent => '事件';

  @override
  String get sending => '发送中…';

  @override
  String get noMoreMessages => '没有更多消息';

  @override
  String get forked => '已派生';

  @override
  String get sendFailedTitle => '发送失败';

  @override
  String get modelError => '模型错误';
}
