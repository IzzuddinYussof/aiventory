import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'item_movement_history_model.dart';
export 'item_movement_history_model.dart';

class _HistoryItemRow {
  const _HistoryItemRow({
    required this.movement,
    required this.itemName,
    required this.createdAt,
  });

  final InventoryMovementStruct movement;
  final String itemName;
  final int createdAt;
}

class ItemMovementHistoryWidget extends StatefulWidget {
  const ItemMovementHistoryWidget({
    super.key,
    int? inventoryId,
    String? itemName,
    String? branch,
    int? expiryDate,
  })  : inventoryId = inventoryId ?? 0,
        itemName = itemName ?? 'Inventory Item',
        branch = branch ?? '',
        expiryDate = expiryDate ?? 0;

  final int inventoryId;
  final String itemName;
  final String branch;
  final int expiryDate;

  static String routeName = 'itemMovementHistory';
  static String routePath = '/itemMovementHistory';

  @override
  State<ItemMovementHistoryWidget> createState() =>
      _ItemMovementHistoryWidgetState();
}

class _ItemMovementHistoryWidgetState extends State<ItemMovementHistoryWidget> {
  late ItemMovementHistoryModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final List<_HistoryItemRow> _historyItems = [];
  final Set<int> _deletingIds = {};

  int _currentPage = 1;
  int _pageTotal = 1;
  int _perPage = 25;
  int _itemsTotal = 0;
  int? _nextPage;
  int? _prevPage;

  bool _isInitialLoading = true;
  bool _isPageLoading = false;
  String? _errorMessage;

  String get _resolvedBranch =>
      widget.branch.isNotEmpty ? widget.branch : FFAppState().branch;

  String get _resolvedExpiryDateRaw =>
      widget.expiryDate > 0 ? widget.expiryDate.toString() : '';

  String get _resolvedExpiryDateForHistory {
    if (_resolvedExpiryDateRaw.isEmpty || _resolvedExpiryDateRaw == '0') {
      return '';
    }
    final timestamp = int.tryParse(_resolvedExpiryDateRaw);
    if (timestamp == null || timestamp <= 0) {
      return _resolvedExpiryDateRaw;
    }
    return dateTimeFormat(
      'yyyy-MM-dd',
      DateTime.fromMillisecondsSinceEpoch(timestamp),
    );
  }

  int? _asInt(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  List<_HistoryItemRow> _parseHistoryItems(dynamic responseBody) {
    final itemsJson = getJsonField(responseBody, r'''$.items''');
    final source = itemsJson is List
        ? itemsJson
        : (responseBody is List ? responseBody : <dynamic>[]);

    return source
        .map<_HistoryItemRow?>((item) {
          if (item is! Map) {
            return null;
          }
          final movementMap = Map<String, dynamic>.from(item);
          final expiryDate = movementMap['expiry_date'];
          if (expiryDate != null && expiryDate is! String) {
            movementMap['expiry_date'] = expiryDate.toString();
          }
          final movement = InventoryMovementStruct.maybeFromMap(movementMap);
          if (movement == null) {
            return null;
          }

          final itemNameRaw = movementMap['item_name']?.toString().trim() ?? '';
          final resolvedItemName =
              itemNameRaw.isNotEmpty ? itemNameRaw : widget.itemName;
          final createdAt =
              _asInt(movementMap['created_at']) ?? movement.createdAt;

          return _HistoryItemRow(
            movement: movement,
            itemName: resolvedItemName,
            createdAt: createdAt,
          );
        })
        .withoutNulls
        .toList()
        .cast<_HistoryItemRow>();
  }

  void _applyPagingState(dynamic responseBody) {
    final paging = getJsonField(responseBody, r'''$.paging''');
    final page = _asInt(getJsonField(paging, r'''$.page''')) ??
        _asInt(getJsonField(responseBody, r'''$.curPage''')) ??
        _asInt(getJsonField(responseBody, r'''$.page''')) ??
        1;
    final perPage = _asInt(getJsonField(paging, r'''$.per_page''')) ??
        _asInt(getJsonField(responseBody, r'''$.perPage''')) ??
        _perPage;
    final itemsTotal = _asInt(getJsonField(paging, r'''$.items_total''')) ??
        _asInt(getJsonField(responseBody, r'''$.itemsTotal''')) ??
        _itemsTotal;
    final pageTotal = _asInt(getJsonField(paging, r'''$.page_total''')) ??
        _asInt(getJsonField(responseBody, r'''$.pageTotal''')) ??
        _pageTotal;
    final nextPage = _asInt(getJsonField(paging, r'''$.next_page''')) ??
        _asInt(getJsonField(responseBody, r'''$.nextPage'''));
    final prevPage = _asInt(getJsonField(paging, r'''$.prev_page''')) ??
        _asInt(getJsonField(responseBody, r'''$.prevPage'''));

    _currentPage = page > 0 ? page : 1;
    _perPage = perPage > 0 ? perPage : 25;
    _itemsTotal = itemsTotal >= 0 ? itemsTotal : 0;
    _pageTotal = pageTotal > 0
        ? pageTotal
        : (_itemsTotal > 0 && _perPage > 0
            ? ((_itemsTotal + _perPage - 1) ~/ _perPage)
            : 1);
    _nextPage = nextPage ?? (_currentPage < _pageTotal ? _currentPage + 1 : null);
    _prevPage = prevPage ?? (_currentPage > 1 ? _currentPage - 1 : null);
  }

  String _responseMessage(dynamic body, String fallback) {
    final message = getJsonField(body, r'''$.message''');
    if (message == null) {
      return fallback;
    }
    final msg = message.toString();
    return msg.isEmpty ? fallback : msg;
  }

  Future<void> _loadHistoryPage(
    int page, {
    bool isInitial = false,
  }) async {
    if (_isPageLoading) {
      return;
    }

    if (isInitial) {
      _isInitialLoading = true;
    } else {
      _isPageLoading = true;
    }
    _errorMessage = null;
    safeSetState(() {});

    _model.itemHistoryResponse = await InventoryMovementGroup.itemHistoryCall.call(
      inventoryId: widget.inventoryId.toString(),
      expiryDate: _resolvedExpiryDateForHistory,
      branch: _resolvedBranch,
      page: page,
      perPage: _perPage,
    );

    if ((_model.itemHistoryResponse?.succeeded ?? false)) {
      _historyItems
        ..clear()
        ..addAll(_parseHistoryItems(_model.itemHistoryResponse?.jsonBody));
      _applyPagingState(_model.itemHistoryResponse?.jsonBody);
    } else {
      _errorMessage = _responseMessage(
        _model.itemHistoryResponse?.jsonBody,
        'Unable to load item movement history.',
      );
      _historyItems.clear();
    }

    _isInitialLoading = false;
    _isPageLoading = false;
    safeSetState(() {});

    if (_errorMessage == null &&
        _historyItems.isEmpty &&
        _currentPage > 1 &&
        _currentPage > _pageTotal) {
      await _loadHistoryPage(_pageTotal);
    }
  }

  Future<void> _deleteMovement(InventoryMovementStruct movement) async {
    final shouldDelete = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: Text('Delete movement?'),
            content: Text(
              'This will remove movement #${movement.id}. This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: Text(
                  'Delete',
                  style: TextStyle(color: FlutterFlowTheme.of(context).error),
                ),
              ),
            ],
          ),
        ) ??
        false;

    if (!shouldDelete) {
      return;
    }

    _deletingIds.add(movement.id);
    safeSetState(() {});

    final expiryDateForDelete = movement.expiryDate.isNotEmpty
        ? movement.expiryDate
        : _resolvedExpiryDateRaw;

    _model.itemMovementDeleteResponse =
        await InventoryMovementGroup.itemMovementDeleteCall.call(
      inventoryMovementId: movement.id.toString(),
      inventoryId: widget.inventoryId.toString(),
      branch: _resolvedBranch,
      expiryDate: expiryDateForDelete,
    );

    if ((_model.itemMovementDeleteResponse?.succeeded ?? false)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Movement deleted successfully.'),
          duration: Duration(seconds: 2),
        ),
      );
      await _loadHistoryPage(_currentPage);
    } else {
      await showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text('Delete failed'),
          content: Text(
            _responseMessage(
              _model.itemMovementDeleteResponse?.jsonBody,
              'Unable to delete this movement.',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('Ok'),
            ),
          ],
        ),
      );
    }

    _deletingIds.remove(movement.id);
    safeSetState(() {});
  }

  String _formatTimestamp(int value) {
    if (value <= 0) {
      return '-';
    }
    return dateTimeFormat(
      'dd/MM/yyyy HH:mm',
      DateTime.fromMillisecondsSinceEpoch(value),
    );
  }

  String _formatQuantity(double quantity) {
    if (quantity == quantity.truncateToDouble()) {
      return quantity.toInt().toString();
    }
    return quantity.toStringAsFixed(2);
  }

  String _formatExpiryDate(String expiryDate) {
    if (expiryDate.isEmpty || expiryDate == '0') {
      return 'No expiry';
    }
    final timestamp = int.tryParse(expiryDate);
    if (timestamp == null || timestamp <= 0) {
      return expiryDate;
    }
    return dateTimeFormat('d/M/y', DateTime.fromMillisecondsSinceEpoch(timestamp));
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ItemMovementHistoryModel());

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadHistoryPage(1, isInitial: true);
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canGoPrev = !_isPageLoading && (_prevPage != null || _currentPage > 1);
    final canGoNext =
        !_isPageLoading && (_nextPage != null || _currentPage < _pageTotal);
    final showPaginationControls = !_isInitialLoading &&
        _errorMessage == null &&
        (_pageTotal > 1 || _nextPage != null || _prevPage != null);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            'Item Movement History',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.interTight(
                    fontWeight:
                        FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                  ),
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                  fontStyle:
                      FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                ),
          ),
        ),
        body: SafeArea(
          top: true,
          child: RefreshIndicator(
            onRefresh: () => _loadHistoryPage(_currentPage),
            child: ListView(
              padding: EdgeInsetsDirectional.fromSTEB(12.0, 16.0, 12.0, 24.0),
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        FlutterFlowTheme.of(context).primary.withValues(alpha: 0.14),
                        FlutterFlowTheme.of(context)
                            .secondaryBackground
                            .withValues(alpha: 0.9),
                      ],
                      begin: AlignmentDirectional(-1.0, -1.0),
                      end: AlignmentDirectional(1.0, 1.0),
                    ),
                    borderRadius: BorderRadius.circular(14.0),
                    border: Border.all(
                      color: FlutterFlowTheme.of(context).alternate,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(14.0, 14.0, 14.0, 14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.itemName,
                          maxLines: 2,
                          style: FlutterFlowTheme.of(context).titleLarge.override(
                                font: GoogleFonts.interTight(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .titleLarge
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleLarge
                                      .fontStyle,
                                ),
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .titleLarge
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .titleLarge
                                    .fontStyle,
                              ),
                        ),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: [
                            Chip(
                              label: Text('ID: ${widget.inventoryId}'),
                              visualDensity: VisualDensity.compact,
                            ),
                            Chip(
                              label: Text(
                                'Branch: ${_resolvedBranch.isNotEmpty ? _resolvedBranch : '-'}',
                              ),
                              visualDensity: VisualDensity.compact,
                            ),
                            Chip(
                              label: Text(
                                'Expiry: ${_resolvedExpiryDateRaw.isNotEmpty ? _formatExpiryDate(_resolvedExpiryDateRaw) : 'All'}',
                              ),
                              visualDensity: VisualDensity.compact,
                            ),
                          ],
                        ),
                        Text(
                          'Swipe left on a movement row to delete.',
                          style: FlutterFlowTheme.of(context).labelMedium.override(
                                font: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontStyle,
                                ),
                                letterSpacing: 0.0,
                                color: FlutterFlowTheme.of(context).secondaryText,
                                fontWeight: FontWeight.w500,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontStyle,
                              ),
                        ),
                      ].divide(SizedBox(height: 10.0)),
                    ),
                  ),
                ),
                if (_isPageLoading)
                  LinearProgressIndicator(
                    minHeight: 3.0,
                    color: FlutterFlowTheme.of(context).primary,
                    backgroundColor: FlutterFlowTheme.of(context).alternate,
                  ),
                if (_isInitialLoading)
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 28.0, 0.0, 0.0),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: FlutterFlowTheme.of(context).primary,
                      ),
                    ),
                  ),
                if (!_isInitialLoading && _errorMessage != null)
                  Container(
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: FlutterFlowTheme.of(context).error,
                        width: 1.0,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(14.0),
                      child: Column(
                        children: [
                          Text(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: FlutterFlowTheme.of(context).bodyMedium,
                          ),
                          SizedBox(
                            width: 160.0,
                            child: ElevatedButton(
                              onPressed: () async {
                                await _loadHistoryPage(_currentPage);
                              },
                              child: Text('Retry'),
                            ),
                          ),
                        ].divide(SizedBox(height: 10.0)),
                      ),
                    ),
                  ),
                if (!_isInitialLoading &&
                    _errorMessage == null &&
                    _historyItems.isEmpty)
                  Container(
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: FlutterFlowTheme.of(context).alternate,
                        width: 1.0,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(12.0, 22.0, 12.0, 22.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.history_toggle_off_rounded,
                            size: 36.0,
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                          Text(
                            'No movement history found.',
                            style: FlutterFlowTheme.of(context).bodyMedium,
                          ),
                        ].divide(SizedBox(height: 8.0)),
                      ),
                    ),
                  ),
                if (!_isInitialLoading && _errorMessage == null)
                  ..._historyItems.map(
                    (item) => _buildSwipeableMovementCard(context, item),
                  ),
                if (showPaginationControls)
                  Container(
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: FlutterFlowTheme.of(context).alternate,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 12.0, 12.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Page $_currentPage / $_pageTotal',
                                style: FlutterFlowTheme.of(context).titleSmall,
                              ),
                              Text(
                                '$_itemsTotal records',
                                style: FlutterFlowTheme.of(context).labelMedium,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextButton.icon(
                                  onPressed: canGoPrev
                                      ? () async {
                                          await _loadHistoryPage(
                                            _prevPage ?? (_currentPage - 1),
                                          );
                                        }
                                      : null,
                                  icon: Icon(Icons.chevron_left_rounded),
                                  label: Text('Previous'),
                                ),
                              ),
                              SizedBox(width: 10.0),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: canGoNext
                                      ? () async {
                                          await _loadHistoryPage(
                                            _nextPage ?? (_currentPage + 1),
                                          );
                                        }
                                      : null,
                                  icon: Icon(Icons.chevron_right_rounded),
                                  label: Text('Next'),
                                ),
                              ),
                            ],
                          ),
                        ].divide(SizedBox(height: 10.0)),
                      ),
                    ),
                  ),
              ].divide(SizedBox(height: 12.0)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeableMovementCard(
    BuildContext context,
    _HistoryItemRow item,
  ) {
    final movement = item.movement;
    final isDeleting = _deletingIds.contains(movement.id);

    return Dismissible(
      key: ValueKey('movement_${movement.id}_${item.createdAt}'),
      direction:
          isDeleting ? DismissDirection.none : DismissDirection.endToStart,
      dismissThresholds: const {DismissDirection.endToStart: 0.35},
      background: const SizedBox.shrink(),
      secondaryBackground: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFB3261E),
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 20.0, 0.0),
        alignment: AlignmentDirectional.centerEnd,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.delete_outline_rounded,
              color: Colors.white,
              size: 24.0,
            ),
            const SizedBox(width: 8.0),
            Text(
              'Delete',
              style: FlutterFlowTheme.of(context).titleSmall.override(
                    font: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                    ),
                    color: Colors.white,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w700,
                    fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                  ),
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        if (_deletingIds.contains(movement.id)) {
          return false;
        }
        await _deleteMovement(movement);
        return false;
      },
      child: _buildMovementCard(context, item),
    );
  }

  Widget _buildMovementCard(
    BuildContext context,
    _HistoryItemRow item,
  ) {
    final movement = item.movement;
    final isNegative = movement.quantity < 0;
    final quantityColor =
        isNegative ? const Color(0xFF8B1E1E) : const Color(0xFF1B5E20);
    final directionLabel = isNegative ? 'OUT' : 'IN';
    final quantityLabel = _formatQuantity(movement.quantity.abs());
    final createdAt = item.createdAt > 0 ? item.createdAt : movement.createdAt;
    final isDeleting = _deletingIds.contains(movement.id);

    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1.0,
        ),
        boxShadow: [
          const BoxShadow(
            blurRadius: 8.0,
            color: Color(0x12000000),
            offset: Offset(0.0, 3.0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(14.0, 14.0, 14.0, 14.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatTimestamp(createdAt),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: FlutterFlowTheme.of(context).titleMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleMedium
                                .fontStyle,
                          ),
                          letterSpacing: 0.0,
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontWeight: FontWeight.w700,
                          fontStyle: FlutterFlowTheme.of(context)
                              .titleMedium
                              .fontStyle,
                          fontSize: 18.0,
                        ),
                  ),
                  Text(
                    item.itemName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontStyle:
                                FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                          ),
                          letterSpacing: 0.0,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontWeight: FontWeight.w600,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                  ),
                  Text(
                    'Movement #${movement.id}',
                    style: FlutterFlowTheme.of(context).labelSmall,
                  ),
                ].divide(const SizedBox(height: 8.0)),
              ),
            ),
            const SizedBox(width: 12.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: quantityColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: quantityColor.withValues(alpha: 0.35),
                    ),
                  ),
                  padding: const EdgeInsetsDirectional.fromSTEB(
                    14.0,
                    10.0,
                    14.0,
                    10.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        directionLabel,
                        style: FlutterFlowTheme.of(context).labelMedium.override(
                              font: GoogleFonts.inter(
                                fontWeight: FontWeight.w700,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontStyle,
                              ),
                              color: quantityColor,
                              letterSpacing: 1.0,
                              fontWeight: FontWeight.w700,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .fontStyle,
                            ),
                      ),
                      Text(
                        '${isNegative ? '-' : '+'}$quantityLabel',
                        style: FlutterFlowTheme.of(context).titleLarge.override(
                              font: GoogleFonts.interTight(
                                fontWeight: FontWeight.w800,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .titleLarge
                                    .fontStyle,
                              ),
                              color: quantityColor,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w800,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .titleLarge
                                  .fontStyle,
                              fontSize: 28.0,
                            ),
                      ),
                    ],
                  ),
                ),
                if (isDeleting)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: SizedBox(
                      width: 18.0,
                      height: 18.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        color: FlutterFlowTheme.of(context).primary,
                      ),
                    ),
                  )
                else
                  const SizedBox.shrink(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
