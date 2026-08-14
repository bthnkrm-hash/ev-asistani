import 'package:flutter/material.dart';

void main() => runApp(const EvAsistaniApp());

class EvAsistaniApp extends StatefulWidget {
  const EvAsistaniApp({super.key});
  @override
  State<EvAsistaniApp> createState() => _EvAsistaniAppState();
}

class _EvAsistaniAppState extends State<EvAsistaniApp> {
  ThemeMode themeMode = ThemeMode.system;
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ev Asistanı',
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFF4F46E5), scaffoldBackgroundColor: const Color(0xFFF7F7FA)),
        darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark, colorSchemeSeed: const Color(0xFF818CF8)),
        themeMode: themeMode,
        home: HomePage(
          themeMode: themeMode,
          onThemeChanged: (v) => setState(() => themeMode = v),
        ),
      );
}

class HomePage extends StatefulWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;
  const HomePage({super.key, required this.themeMode, required this.onThemeChanged});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  final List<String> shopping = ['Süt', 'Yumurta', 'Mama', 'Kahve'];
  final TextEditingController shoppingController = TextEditingController();

  @override
  void dispose() {
    shoppingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _HomeContent(shoppingCount: shopping.length),
      _ShoppingPage(items: shopping, onAdd: _addShopping, onToggle: _removeShopping),
      const _PlansPage(),
      _SettingsPage(themeMode: widget.themeMode, onThemeChanged: widget.onThemeChanged),
    ];
    return Scaffold(
      body: SafeArea(child: pages[selectedIndex]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddSheet,
        icon: const Icon(Icons.add),
        label: const Text('Ekle'),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (i) => setState(() => selectedIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Ana Sayfa'),
          NavigationDestination(icon: Icon(Icons.shopping_cart_outlined), selectedIcon: Icon(Icons.shopping_cart), label: 'Alışveriş'),
          NavigationDestination(icon: Icon(Icons.calendar_month_outlined), selectedIcon: Icon(Icons.calendar_month), label: 'Planlar'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'Ayarlar'),
        ],
      ),
    );
  }

  void _addShopping(String item) {
    final value = item.trim();
    if (value.isEmpty) return;
    setState(() => shopping.add(value));
    shoppingController.clear();
  }

  void _removeShopping(int index) => setState(() => shopping.removeAt(index));

  void _showAddSheet() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('Ne ekleyelim?', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _AddTile(icon: Icons.shopping_cart_outlined, title: 'Alışveriş ürünü', onTap: () { Navigator.pop(context); _showShoppingDialog(); }),
            _AddTile(icon: Icons.task_alt, title: 'Ev işi', onTap: () => Navigator.pop(context)),
            _AddTile(icon: Icons.calendar_month_outlined, title: 'Plan', onTap: () => Navigator.pop(context)),
            _AddTile(icon: Icons.payments_outlined, title: 'Harcama', onTap: () => Navigator.pop(context)),
          ]),
        ),
      ),
    );
  }

  void _showShoppingDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Alışverişe ekle'),
        content: TextField(
          controller: shoppingController,
          autofocus: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) { _addShopping(shoppingController.text); Navigator.pop(context); },
          decoration: const InputDecoration(hintText: 'Örn. Ekmek', border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Vazgeç')),
          FilledButton(onPressed: () { _addShopping(shoppingController.text); Navigator.pop(context); }, child: const Text('Ekle')),
        ],
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  final int shoppingCount;
  const _HomeContent({required this.shoppingCount});
  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 110),
        children: [
          const Text('Günaydın 👋', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 4),
          const Text('Bugün evde ne var?', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
          const SizedBox(height: 22),
          Card(color: Theme.of(context).colorScheme.primaryContainer, elevation: 0, child: const Padding(padding: EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('BU AYIN BÜTÇESİ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            SizedBox(height: 8), Text('₺6.500 kaldı', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
            SizedBox(height: 12), LinearProgressIndicator(value: .74, minHeight: 9), SizedBox(height: 8), Text('₺18.500 / ₺25.000 kullanıldı')
          ]))),
          const SizedBox(height: 14),
          _InfoCard(icon: Icons.shopping_cart_outlined, title: 'Alışveriş', subtitle: '$shoppingCount ürün bekliyor', trailing: 'Listeyi aç'),
          const SizedBox(height: 14),
          const _InfoCard(icon: Icons.calendar_month_outlined, title: 'Yaklaşanlar', subtitle: 'Yarın · Araç bakımı', trailing: 'Takvime git'),
          const SizedBox(height: 14),
          const Card(elevation: 0, child: Padding(padding: EdgeInsets.all(18), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CircleAvatar(child: Icon(Icons.lightbulb_outline)), SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Ben Hatırlatırım', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)), SizedBox(height: 6), Text('Mama yaklaşık 5 gün içinde bitebilir.')
            ]))
          ]))),
        ],
      );
}

class _ShoppingPage extends StatelessWidget {
  final List<String> items;
  final ValueChanged<String> onAdd;
  final ValueChanged<int> onToggle;
  const _ShoppingPage({required this.items, required this.onAdd, required this.onToggle});
  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 110),
        children: [
          const Text('Alışveriş', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text('${items.length} ürün listede', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 18),
          if (items.isEmpty) const Card(child: Padding(padding: EdgeInsets.all(24), child: Center(child: Text('Liste boş. + Ekle ile ürün ekleyebilirsin.')))),
          ...items.asMap().entries.map((e) => Card(elevation: 0, child: ListTile(leading: const CircleAvatar(child: Icon(Icons.shopping_basket_outlined)), title: Text(e.value), trailing: IconButton(icon: const Icon(Icons.check_circle_outline), onPressed: () => onToggle(e.key)))),
        ],
      );
}

class _PlansPage extends StatelessWidget {
  const _PlansPage();
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.fromLTRB(20, 24, 20, 110), children: const [
    Text('Planlar', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800)), SizedBox(height: 18),
    Card(child: ListTile(leading: CircleAvatar(child: Icon(Icons.directions_car)), title: Text('Araç bakımı'), subtitle: Text('Yarın · 10:00'))),
    Card(child: ListTile(leading: CircleAvatar(child: Icon(Icons.cleaning_services_outlined)), title: Text('Ev temizliği'), subtitle: Text('Cumartesi · 11:00'))),
  ]);
}

class _SettingsPage extends StatelessWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;
  const _SettingsPage({required this.themeMode, required this.onThemeChanged});
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.fromLTRB(20, 24, 20, 110), children: [
    const Text('Ayarlar', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800)), const SizedBox(height: 18),
    Card(child: Column(children: [
      const ListTile(leading: CircleAvatar(child: Icon(Icons.palette_outlined)), title: Text('Tema'), subtitle: Text('Görünümü seç')),
      RadioListTile<ThemeMode>(value: ThemeMode.system, groupValue: themeMode, onChanged: (v) => onThemeChanged(v!), title: const Text('Sistem')),
      RadioListTile<ThemeMode>(value: ThemeMode.light, groupValue: themeMode, onChanged: (v) => onThemeChanged(v!), title: const Text('Açık')),
      RadioListTile<ThemeMode>(value: ThemeMode.dark, groupValue: themeMode, onChanged: (v) => onThemeChanged(v!), title: const Text('Koyu')),
    ])),
  ]);
}

class _InfoCard extends StatelessWidget {
  final IconData icon; final String title; final String subtitle; final String trailing;
  const _InfoCard({required this.icon, required this.title, required this.subtitle, required this.trailing});
  @override
  Widget build(BuildContext context) => Card(elevation: 0, child: ListTile(contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6), leading: CircleAvatar(child: Icon(icon)), title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text(subtitle), trailing: Text(trailing, style: TextStyle(color: Theme.of(context).colorScheme.primary)));
}

class _AddTile extends StatelessWidget {
  final IconData icon; final String title; final VoidCallback onTap;
  const _AddTile({required this.icon, required this.title, required this.onTap});
  @override
  Widget build(BuildContext context) => ListTile(leading: Icon(icon), title: Text(title), onTap: onTap, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)));
}
