import 'package:flutter/material.dart';

import '../i18n.dart';
import '../models.dart';
import '../navigation.dart';
import '../services/models_dev.dart';
import '../store.dart';
import '../theme/app_theme.dart';
import '../widgets/dialogs.dart';
import '../icons.dart';

/// Map a raw API type string to its localized display label.
String apiTypeLabel(BuildContext context, String apiType) {
  switch (apiType) {
    case 'openai-compatible':
      return context.l10n.apiTypeOpenaiCompat;
    case 'openai':
      return context.l10n.apiTypeOpenai;
    case 'anthropic':
      return context.l10n.apiTypeAnthropic;
    case 'gemini':
    case 'google':
      return context.l10n.apiTypeGemini;
    case 'deepseek':
      return context.l10n.apiTypeDeepseek;
    case 'cohere':
      return context.l10n.apiTypeCohere;
    case 'vercel-compatible-gateway':
      return context.l10n.apiTypeGateway;
    default:
      return apiType;
  }
}

/// The 8 first-class modalities, in section order. Mirrors the server matrix
/// (ListProvidersCatalog); the live response overrides the per-protocol sets.
const List<String> kModelCapabilities = [
  'text',
  'image',
  'video',
  'speech',
  'transcription',
  'embedding',
  'rerank',
  'realtime',
];

/// Icon + color for a capability (test selector / gateway rows).
Widget capabilityIcon(
  BuildContext context,
  String capability, {
  double size = 14,
}) {
  final colors = colorsOf(context);
  switch (capability) {
    case 'image':
      return Icon(AppIcons.image, size: size, color: colors.warning);
    case 'video':
      return Icon(
        AppIcons.video,
        size: size,
        color: colors.destructive,
      );
    case 'speech':
      return Icon(AppIcons.audio, size: size, color: colors.primary);
    case 'transcription':
      return Icon(
        AppIcons.mic_vocal,
        size: size,
        color: colors.accent,
      );
    default:
      return Icon(
        AppIcons.chat,
        size: size,
        color: colors.success,
      );
  }
}

/// Localized capability label.
String capabilityLabel(BuildContext context, String capability) {
  switch (capability) {
    case 'image':
      return context.l10n.capImage;
    case 'video':
      return context.l10n.capVideo;
    case 'speech':
      return context.l10n.capSpeech;
    case 'transcription':
      return context.l10n.capTranscription;
    case 'embedding':
      return context.l10n.capEmbedding;
    case 'rerank':
    case 'reranking':
      return context.l10n.capReranking;
    default:
      return context.l10n.capText;
  }
}

// ---------------------------------------------------------------------------
// Providers page — one SECTION PER MODALITY (semantic grouping). A provider
// serves exactly one capability and all of its models share it, so "the models
// of modality X" is simply that section's registered providers. Only the TEXT
// section carries the tenant default model.
// ---------------------------------------------------------------------------
class ProvidersListScreen extends StatefulWidget {
  final AppStore store;
  /// Whether this page is the top of the tablet split (show a back arrow).
  final bool showBack;
  const ProvidersListScreen({super.key, required this.store, this.showBack = true});

  @override
  State<ProvidersListScreen> createState() => _ProvidersListScreenState();
}

class _ProvidersListScreenState extends State<ProvidersListScreen> {
  AppStore get store => widget.store;
  Map<String, ProviderInfo> _providers = {};
  bool _loading = true;
  bool _providersLoading = false;
  String _defaultModel = '';

  @override
  void initState() {
    super.initState();
    store.addListener(_onStore);
    _load();
  }

  @override
  void dispose() {
    store.removeListener(_onStore);
    super.dispose();
  }

  int _seenProvidersRevision = 0;

  void _onStore() {
    if (!mounted) return;
    setState(() {});
    // Only refetch when a provider actually changed — not on every store
    // notification (message deltas, drafts, navigation all notify).
    if (store.providersRevision == _seenProvidersRevision) return;
    _seenProvidersRevision = store.providersRevision;
    if (_providersLoading) return;
    _reload();
  }

  Future<void> _reload() async {
    _providersLoading = true;
    try {
      final p = await store.api.providers();
      if (mounted) setState(() => _providers = p);
    } catch (_) {}
    _providersLoading = false;
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      _defaultModel = await store.api.config('default_model');
    } catch (_) {}
    await _reload();
    if (mounted) setState(() => _loading = false);
  }

  void _add(String capability) {
    store.beginProviderDraft(
      ProviderInfo(
        providerId: '',
        capability: capability,
        apiType: 'openai-compatible',
        baseUrl: '',
        apiKey: '',
        models: const [],
      ),
    );
    store.pushPage(const ProviderFormPage());
  }

  void _edit(ProviderInfo p) {
    store.beginProviderDraft(p);
    store.pushPage(const ProviderFormPage());
  }

  @override
  Widget build(BuildContext context) {
    final colors = colorsOf(context);
    final text = textOf(context);
    final all = _providers.values.toList()
      ..sort((a, b) => a.providerId.compareTo(b.providerId));
    return Scaffold(
      appBar: AppBar(
        leading: widget.showBack
            ? IconButton(
                icon: const Icon(AppIcons.back),
                onPressed: () => store.popPage(),
              )
            : null,
        title: Text(context.l10n.llmProviders),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                // ONE SECTION PER MODALITY (semantic grouping). Only the TEXT
                // section carries the tenant default model.
                for (final cap in kModelCapabilities) ...[
                  _sectionHeader(
                    context,
                    capabilityLabel(context, cap),
                    onAdd: () => _add(cap),
                  ),
                  if (cap == 'text') _defaultProviderTile(context, all, colors),
                  for (final p in all.where((p) => p.capability == cap))
                    _providerTile(context, p),
                ],
                if (all.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Text(
                      context.l10n.noProviders,
                      style: text.meta.copyWith(color: colors.mutedForeground),
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _sectionHeader(BuildContext context, String label,
      {VoidCallback? onAdd}) {
    final text = textOf(context);
    final colors = colorsOf(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.md, AppSpacing.sm, AppSpacing.xs),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: text.micro.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
                color: colors.mutedForeground,
              ),
            ),
          ),
          if (onAdd != null)
            IconButton(
              visualDensity: VisualDensity.compact,
              tooltip: context.l10n.addProvider,
              icon: Icon(AppIcons.add, size: 18, color: colors.primary),
              onPressed: onAdd,
            ),
        ],
      ),
    );
  }

  Widget _providerTile(BuildContext context, ProviderInfo p) {
    final colors = colorsOf(context);
    final text = textOf(context);
    return ListTile(
      leading: capabilityIcon(context, p.capability, size: 20),
      title: Text(
        p.providerId,
        style: text.meta.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        '${apiTypeLabel(context, p.apiType)} · '
        '${context.l10n.modelsCount('${p.models.length}')}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: text.micro.copyWith(color: colors.mutedForeground),
      ),
      trailing: const Icon(AppIcons.chevron_right, size: 18),
      onTap: () => _edit(p),
    );
  }

  /// The tenant DEFAULT text model, chosen inline here (not in a separate
  /// settings box). Selecting a provider's text model sets `default_model`,
  /// which the agent applies to every session created without an explicit
  /// model. Value is the canonical `provider_id/model_id` ref.
  Widget _defaultProviderTile(
    BuildContext context,
    List<ProviderInfo> providers,
    AppColors colors,
  ) {
    final text = textOf(context);
    final refs = <String>[
      for (final p in providers)
        if (p.capability == 'text')
          for (final m in p.models)
            if ((m.contextLimit ?? 0) > 0) '${p.providerId}/${m.id}',
    ]..sort();
    if (_defaultModel.isNotEmpty && !refs.contains(_defaultModel)) {
      refs.insert(0, _defaultModel);
    }
    return ListTile(
      leading: Icon(AppIcons.star, size: 20, color: colors.primary),
      title: Text(
        context.l10n.defaultModel,
        style: text.meta.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        _defaultModel.isEmpty ? context.l10n.none : _defaultModel,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: text.micro.copyWith(color: colors.mutedForeground),
      ),
      trailing: const Icon(AppIcons.chevron_right, size: 18),
      onTap: () => _pickDefaultModel(context, refs),
    );
  }

  Future<void> _pickDefaultModel(
    BuildContext context,
    List<String> refs,
  ) async {
    final picked = await showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(ctx.l10n.defaultModel),
        children: [
          for (final ref in ['', ...refs])
            RadioListTile<String>(
              value: ref,
              groupValue: _defaultModel,
              title: Text(ref.isEmpty ? ctx.l10n.none : ref,
                  style: textOf(ctx).meta),
              onChanged: (v) => Navigator.pop(ctx, v ?? ''),
            ),
        ],
      ),
    );
    if (picked == null || picked == _defaultModel) return;
    try {
      await store.api.setConfigKey('default_model', picked);
      if (mounted) setState(() => _defaultModel = picked);
    } catch (e) {
      if (mounted) showErrorToast(context, '$e');
    }
  }
}

// ---------------------------------------------------------------------------
// Text provider form — id / api type / base URL / key + text models (each
// requires a context_limit). "+" opens the text-model form.
// ---------------------------------------------------------------------------
class ProviderFormScreen extends StatefulWidget {
  final AppStore store;
  final bool showBack;
  const ProviderFormScreen({super.key, required this.store, this.showBack = true});

  @override
  State<ProviderFormScreen> createState() => _ProviderFormScreenState();
}

class _ProviderFormScreenState extends State<ProviderFormScreen> {
  AppStore get store => widget.store;
  ProviderDraft? get draft => store.providerDraft;

  TextEditingController? _id;
  TextEditingController? _url;
  TextEditingController? _key;
  String _apiType = 'openai-compatible';
  bool _registering = false;

  @override
  void initState() {
    super.initState();
    // Refresh the capability matrix; forms read store.providerCatalog (the
    // bundled fallback applies until this answers).
    store.refreshProviderCatalog();
    final d = draft;
    if (d != null) {
      _id = TextEditingController(text: d.id);
      _url = TextEditingController(text: d.baseUrl);
      _key = TextEditingController(text: d.apiKey);
      _apiType = d.apiType;
    }
    store.addListener(_onStore);
  }

  @override
  void dispose() {
    store.removeListener(_onStore);
    _id?.dispose();
    _url?.dispose();
    _key?.dispose();
    super.dispose();
  }

  void _onStore() {
    if (mounted) setState(() {});
  }

  /// The protocols that can serve [capability] (from the server catalog).
  List<String> apiTypesFor(String capability) {
    final out = store.providerCatalog.entries
        .where((e) => e.value.contains(capability))
        .map((e) => e.key)
        .toList()
      ..sort();
    return out.isEmpty ? const ['openai-compatible'] : out;
  }

  Future<void> _pickTemplate() async {
    final d = draft;
    if (d == null) return;
    final picked = await showModalBottomSheet<MdProvider>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const _TemplatePickerSheet(),
    );
    if (picked == null) return;
    setState(() {
      _id?.text = picked.id;
      _url?.text = picked.api.isNotEmpty ? picked.api : (_url?.text ?? '');
      _apiType = ModelsDev.npmToType(picked.npm);
      d.id = picked.id;
      d.baseUrl = _url?.text ?? '';
      d.apiType = _apiType;
      // A non-text provider has no chat models: the catalog's context limits
      // only apply to the text modality.
      final isText = d.capability == 'text';
      d.models
        ..clear()
        ..addAll(
          picked.models
              .map(
                (m) => ProviderModel(
                  id: m.id,
                  name: m.name,
                  contextLimit: isText ? m.contextLimit : 0,
                  modelType: isText ? 'text' : d.capability,
                ),
              )
              .toList(),
        );
    });
  }

  Future<void> _save() async {
    final d = draft;
    if (d == null) return;
    d.id = _id?.text.trim() ?? d.id;
    d.apiType = _apiType;
    d.baseUrl = _url?.text.trim() ?? d.baseUrl;
    d.apiKey = _key?.text ?? d.apiKey;
    if (d.id.isEmpty || d.baseUrl.isEmpty) return;
    // Context limit is required (> 0) for TEXT models only.
    if (d.capability == 'text' &&
        d.models.any((m) => (m.contextLimit ?? 0) <= 0)) {
      showToast(context, context.l10n.contextLengthRequired);
      return;
    }
    setState(() => _registering = true);
    try {
      await store.api.registerProvider(
        ProviderInfo(
          providerId: d.id,
          capability: d.capability,
          apiType: d.apiType,
          baseUrl: d.baseUrl,
          apiKey: d.apiKey,
          models: d.models,
        ),
      );
      store.bumpProvidersRevision();
      store.endProviderDraft();
      showToast(context, context.l10n.saved);
      store.popPage();
    } catch (e) {
      showErrorToast(context, '$e');
    }
    if (mounted) setState(() => _registering = false);
  }

  @override
  Widget build(BuildContext context) {
    final colors = colorsOf(context);
    final text = textOf(context);
    final d = draft;
    if (d == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final canSave =
        (_id?.text.trim().isNotEmpty ?? false) &&
        (_url?.text.trim().isNotEmpty ?? false);
    return Scaffold(
      appBar: AppBar(
        leading: widget.showBack
            ? IconButton(
                icon: const Icon(AppIcons.back),
                onPressed: () {
                  store.endProviderDraft();
                  store.popPage();
                },
              )
            : null,
        title: Text(
          d.isEdit ? context.l10n.settingsTitle : context.l10n.addProvider,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          InputDecorator(
            decoration: InputDecoration(
              labelText: context.l10n.capabilityLabel,
              prefixIcon: capabilityIcon(context, d.capability, size: 18),
            ),
            child: Text(capabilityLabel(context, d.capability),
                style: text.meta.copyWith(color: colors.mutedForeground)),
          ),
          const SizedBox(height: AppSpacing.md),
          InkWell(
            borderRadius: AppRadius.rSm,
            onTap: _pickTemplate,
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: context.l10n.providerTemplate,
                prefixIcon: const Icon(AppIcons.sparkles, size: 18),
              ),
              child: Text(
                context.l10n.providerTemplateHint,
                style: text.meta.copyWith(color: colors.mutedForeground),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _id,
            enabled: !d.isEdit,
            onChanged: (v) {
              d.id = v;
              setState(() {});
            },
            decoration: InputDecoration(labelText: context.l10n.providerIdReq),
          ),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<String>(
            initialValue: apiTypesFor(d.capability).contains(_apiType)
                ? _apiType
                : apiTypesFor(d.capability).first,
            items: [
              // Only the protocols whose wire format serves this modality.
              for (final t in apiTypesFor(d.capability))
                DropdownMenuItem(value: t, child: Text(apiTypeLabel(context, t))),
            ],
            onChanged: (v) => setState(() {
              _apiType = v ?? 'openai-compatible';
              d.apiType = _apiType;
            }),
            decoration: InputDecoration(labelText: context.l10n.apiType),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _url,
            onChanged: (v) {
              d.baseUrl = v;
              setState(() {});
            },
            decoration: InputDecoration(labelText: context.l10n.baseUrlReq),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _key,
            obscureText: true,
            onChanged: (v) => d.apiKey = v,
            decoration: InputDecoration(labelText: context.l10n.apiKeyReq),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: Text(
                  context.l10n.modelsLabel,
                  style: text.meta.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
              IconButton(
                tooltip: context.l10n.addModel,
                icon: Icon(AppIcons.add, size: 20, color: colors.primary),
                onPressed: () => store.pushPage(ProviderModelsPage()),
              ),
            ],
          ),
          if (d.models.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Text(
                context.l10n.providerTemplateHint,
                style: text.micro.copyWith(color: colors.mutedForeground),
              ),
            ),
          for (final m in d.models)
            _ModelRow(
              model: m,
              onTap: () => store.pushPage(ProviderModelsPage(modelId: m.id)),
              onRemove: () => setState(() => d.models.remove(m)),
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: FilledButton(
            onPressed: canSave && !_registering ? _save : null,
            child: Text(
              _registering
                  ? context.l10n.registering
                  : (d.isEdit ? context.l10n.save : context.l10n.register),
            ),
          ),
        ),
      ),
    );
  }
}

/// A compact, tappable model row. A gateway multimodal model shows its kind
/// (image / video / speech / transcription / …) from `model.modelType`; a text
/// model shows its context window. Tapping edits; the × removes it.
class _ModelRow extends StatelessWidget {
  final ProviderModel model;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  const _ModelRow({
    required this.model,
    required this.onTap,
    required this.onRemove,
  });

  /// Localized label for a model kind tag.
  String _typeLabel(BuildContext context, String type) {
    switch (type) {
      case 'text':
      case '':
        return context.l10n.capText;
      case 'image':
        return context.l10n.capImage;
      case 'video':
        return context.l10n.capVideo;
      case 'speech':
        return context.l10n.capSpeech;
      case 'transcription':
        return context.l10n.capTranscription;
      case 'embedding':
        return context.l10n.capEmbedding;
      case 'rerank':
      case 'reranking':
        return context.l10n.capReranking;
      case 'realtime':
        return context.l10n.capRealtime;
      default:
        return type;
    }
  }

  IconData _typeIcon(String type) => switch (type) {
        'image' => AppIcons.image,
        'video' => AppIcons.video,
        'speech' => AppIcons.audio,
        'transcription' => AppIcons.mic_vocal,
        'embedding' => AppIcons.scatter,
        'reranking' || 'rerank' => AppIcons.grip,
        'realtime' => AppIcons.bolt,
        _ => AppIcons.chat,
      };

  @override
  Widget build(BuildContext context) {
    final colors = colorsOf(context);
    final text = textOf(context);
    final isText = (model.contextLimit ?? 0) > 0;
    final type = isText ? 'text' : model.modelType;
    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.xs),
      decoration: BoxDecoration(
        color: colors.muted.withValues(alpha: 0.4),
        borderRadius: AppRadius.rSm,
        border: Border.all(color: colors.border.withValues(alpha: 0.6)),
      ),
      child: InkWell(
        borderRadius: AppRadius.rSm,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.md,
            top: AppSpacing.xs,
            bottom: AppSpacing.xs,
            right: AppSpacing.xs,
          ),
          child: Row(
            children: [
              Icon(
                _typeIcon(type),
                size: 14,
                color: colors.mutedForeground,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  model.id,
                  overflow: TextOverflow.ellipsis,
                  style: text.mono.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                isText
                    ? '${context.l10n.capText} · ${model.contextLimit ?? 0}'
                    : _typeLabel(context, type),
                style: text.micro.copyWith(color: colors.mutedForeground),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(AppIcons.close, size: 16),
                tooltip: context.l10n.delete,
                onPressed: onRemove,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Model form — a SINGLE model of the draft provider's capability (id, name,
// context). A context limit is REQUIRED for text models only; every other
// modality is a non-chat model. The models.dev catalog can prefill.
// ---------------------------------------------------------------------------
class ProviderModelScreen extends StatefulWidget {
  final AppStore store;
  final String? modelId;
  final bool showBack;
  const ProviderModelScreen({super.key, required this.store, this.modelId, this.showBack = true});

  @override
  State<ProviderModelScreen> createState() => _ProviderModelScreenState();
}

class _ProviderModelScreenState extends State<ProviderModelScreen> {
  AppStore get store => widget.store;

  late final TextEditingController _modelIdCtrl;
  late final TextEditingController _modelNameCtrl;
  late final TextEditingController _modelCtxCtrl;

  /// Declared capability (model_type). Defaults to text; options come from
  /// the capability matrix for the DRAFT provider's api type.
  late String _capability;

  bool _testing = false;
  bool? _testOk;
  String? _testMsg;

  bool get _isEdit => widget.modelId != null;

  ProviderModel? _existing() {
    final d = store.providerDraft;
    if (d == null || widget.modelId == null) return null;
    for (final m in d.models) {
      if (m.id == widget.modelId) return m;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    final m = _existing();
    _modelIdCtrl = TextEditingController(text: m?.id ?? '');
    _modelNameCtrl = TextEditingController(text: m?.name ?? '');
    _modelCtxCtrl = TextEditingController(
      text: (m?.contextLimit ?? 0) > 0 ? '${m!.contextLimit}' : '',
    );
    // The model's modality IS the provider's (semantic grouping); the field
    // is read-only and shown for context.
    _capability = _draftCapability();
    store.addListener(_onStore);
  }

  @override
  void dispose() {
    store.removeListener(_onStore);
    _modelIdCtrl.dispose();
    _modelNameCtrl.dispose();
    _modelCtxCtrl.dispose();
    super.dispose();
  }

  void _onStore() {
    if (mounted) setState(() {});
  }

  /// The DRAFT provider's single capability (semantic grouping). The model
  /// form cannot change it; it is fixed by the section the provider lives in.
  String _draftCapability() => store.providerDraft?.capability ?? 'text';

  void _save() {
    final d = store.providerDraft;
    if (d == null) return;
    final mid = _modelIdCtrl.text.trim();
    if (mid.isEmpty) return;
    // context_limit is required (and must be > 0) for TEXT models only.
    final ctx = _capability == 'text' ? int.tryParse(_modelCtxCtrl.text.trim()) : 0;
    if (_capability == 'text' && (ctx == null || ctx <= 0)) {
      showToast(context, context.l10n.contextLengthRequired);
      return;
    }
    final name = _modelNameCtrl.text.trim();
    if (_isEdit) d.models.removeWhere((m) => m.id == widget.modelId);
    d.models.removeWhere((m) => m.id == mid);
    d.models.add(
      ProviderModel(
        id: mid,
        name: name.isNotEmpty ? name : mid,
        contextLimit: ctx,
        modelType: _capability,
      ),
    );
    store.popPage();
  }

  Future<void> _test() async {
    final d = store.providerDraft;
    if (d == null) return;
    final mid = _modelIdCtrl.text.trim();
    if (mid.isEmpty) return;
    setState(() {
      _testing = true;
      _testOk = null;
      _testMsg = null;
    });
    final r = await store.api.testProvider(
      apiType: d.apiType,
      baseUrl: d.baseUrl,
      apiKey: d.apiKey,
      providerId: d.id,
      model: '${d.id}/$mid',
      capability: _capability,
    );
    if (!mounted) return;
    final ok = r['ok'] == true;
    setState(() {
      _testing = false;
      _testOk = ok;
      _testMsg = ok
          ? context.l10n.testModelOk('${r['result'] ?? ''}')
          : '${r['result'] ?? 'Failed'}';
    });
  }

  void _remove() {
    final d = store.providerDraft;
    if (d == null) return;
    d.models.removeWhere((m) => m.id == widget.modelId);
    store.popPage();
  }

  @override
  Widget build(BuildContext context) {
    final colors = colorsOf(context);
    final text = textOf(context);
    final d = store.providerDraft;
    if (d == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        leading: widget.showBack
            ? IconButton(
                icon: const Icon(AppIcons.back),
                onPressed: () => store.popPage(),
              )
            : null,
        title: Text(_isEdit ? context.l10n.modelLabel : context.l10n.addModel),
        actions: [
          if (_isEdit)
            IconButton(
              icon: Icon(
                AppIcons.delete,
                color: colors.destructive,
              ),
              tooltip: context.l10n.delete,
              onPressed: _remove,
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          TextField(
            controller: _modelIdCtrl,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(labelText: context.l10n.modelIdLabel),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _modelNameCtrl,
            decoration: InputDecoration(labelText: context.l10n.modelNameLabel),
          ),
          const SizedBox(height: AppSpacing.md),
          InputDecorator(
            decoration: InputDecoration(
              labelText: context.l10n.capabilityLabel,
              prefixIcon: capabilityIcon(context, _capability, size: 18),
            ),
            child: Text(capabilityLabel(context, _capability),
                style: text.meta.copyWith(color: colors.mutedForeground)),
          ),
          if (_capability == 'text') ...[
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _modelCtxCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: context.l10n.contextLengthLabel,
              ),
            ),
          ],
          if (_capability != 'text')
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Text(
                context.l10n.nonTextModelHint,
                style: text.micro.copyWith(color: colors.mutedForeground),
              ),
            ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: _testing || _modelIdCtrl.text.trim().isEmpty
                    ? null
                    : _test,
                icon: _testing
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(
                        _testOk == true
                            ? AppIcons.success
                            : AppIcons.flask,
                        size: 16,
                        color: _testOk == true ? colors.success : null,
                      ),
                label: Text(
                  _testing
                      ? context.l10n.testing
                      : (_testOk == true
                            ? context.l10n.taskDone
                            : context.l10n.test),
                ),
              ),
            ],
          ),
          if (_testMsg != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Text(
                _testMsg!,
                style: text.micro.copyWith(
                  color: _testOk == true ? colors.success : colors.destructive,
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: FilledButton(
            onPressed: _modelIdCtrl.text.trim().isEmpty ? null : _save,
            child: Text(context.l10n.save),
          ),
        ),
      ),
    );
  }
}

/// models.dev catalog picker (bottom sheet): search + list of providers.
class _TemplatePickerSheet extends StatefulWidget {
  const _TemplatePickerSheet();
  @override
  State<_TemplatePickerSheet> createState() => _TemplatePickerSheetState();
}

class _TemplatePickerSheetState extends State<_TemplatePickerSheet> {
  List<MdProvider> _all = [];
  String _q = '';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final p = await ModelsDev.load();
      if (!mounted) return;
      setState(() {
        _all = p;
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = colorsOf(context);
    final text = textOf(context);
    final filtered = _q.isEmpty
        ? _all
        : _all
              .where(
                (p) =>
                    p.id.toLowerCase().contains(_q.toLowerCase()) ||
                    p.name.toLowerCase().contains(_q.toLowerCase()),
              )
              .toList();
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.7,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: context.l10n.searchModels,
                  prefixIcon: const Icon(AppIcons.search),
                  isDense: true,
                ),
                onChanged: (v) => setState(() => _q = v),
              ),
            ),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (ctx, i) {
                        final p = filtered[i];
                        return ListTile(
                          leading: const Icon(AppIcons.server, size: 18),
                          title: Text(
                            p.name,
                            style: text.meta.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            p.id,
                            style: text.micro.copyWith(
                              color: colors.mutedForeground,
                            ),
                          ),
                          onTap: () => Navigator.pop(context, p),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
