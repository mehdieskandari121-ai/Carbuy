import 'package:flutter/material.dart';

void main() => runApp(const CarBuyApp());

const brand = Color(0xFF0B6B53);
const ink = Color(0xFF17211F);
const muted = Color(0xFF77817E);

class CarBuyApp extends StatelessWidget {
  const CarBuyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'کاربای خودرو',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: brand),
      scaffoldBackgroundColor: const Color(0xFFF6F8F7),
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(backgroundColor: Colors.white, foregroundColor: ink, centerTitle: false),
      cardTheme: CardThemeData(color: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
    ),
    home: const Directionality(textDirection: TextDirection.rtl, child: MainShell()),
  );
}

class Car {
  final String title, year, km, price, city, type;
  final IconData icon;
  const Car(this.title, this.year, this.km, this.price, this.city, this.type, this.icon);
}
const cars = <Car>[
  Car('پژو ۲۰۷ اتوماتیک', '۱۴۰۲', '۱۸٬۰۰۰', '۸۹۰ میلیون تومان', 'اهواز', 'سواری', Icons.directions_car_filled),
  Car('دنا پلاس توربو', '۱۴۰۱', '۴۲٬۰۰۰', '۷۶۰ میلیون تومان', 'اهواز', 'سواری', Icons.directions_car_filled),
  Car('تویوتا هایلوکس', '۱۳۹۸', '۹۵٬۰۰۰', '۳ میلیارد و ۸۰۰ میلیون تومان', 'ماهشهر', 'دوکابین', Icons.local_shipping),
  Car('سمند سورن پلاس', '۱۴۰۳', '۹٬۰۰۰', '۷۲۰ میلیون تومان', 'آبادان', 'سواری', Icons.directions_car_filled),
];

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}
class _MainShellState extends State<MainShell> {
  int tab = 0;
  final Set<int> favorites = {};
  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(onBrowse: () => setState(() => tab = 1), onSell: () => setState(() => tab = 2), favorites: favorites, onFavorite: toggleFavorite, onOpen: openCar),
      SearchPage(favorites: favorites, onFavorite: toggleFavorite, onOpen: openCar),
      SellPage(),
      FavoritesPage(favorites: favorites, onFavorite: toggleFavorite, onOpen: openCar),
      const ProfilePage(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [Container(width: 38,height: 38,decoration: BoxDecoration(color: brand,borderRadius: BorderRadius.circular(12)),child: const Icon(Icons.directions_car_filled,color: Colors.white)), const SizedBox(width: 10), const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('کاربای خودرو',style: TextStyle(fontWeight: FontWeight.w900,fontSize: 17)),Text('بازار خودرو، نزدیک‌تر از همیشه',style: TextStyle(fontSize: 11,color: muted))])]),
        actions: [IconButton(onPressed: () => setState(() => tab = 1), icon: const Icon(Icons.search))],
      ),
      body: IndexedStack(index: tab, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (v) => setState(() => tab = v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'خانه'),
          NavigationDestination(icon: Icon(Icons.search), label: 'جست‌وجو'),
          NavigationDestination(icon: Icon(Icons.add_circle_outline), label: 'ثبت آگهی'),
          NavigationDestination(icon: Icon(Icons.favorite_border), selectedIcon: Icon(Icons.favorite), label: 'نشان‌شده‌ها'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'حساب من'),
        ],
      ),
    );
  }
  void toggleFavorite(int i) => setState(() => favorites.contains(i) ? favorites.remove(i) : favorites.add(i));
  void openCar(int i) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => Directionality(textDirection: TextDirection.rtl, child: CarDetailsPage(car: cars[i], favorite: favorites.contains(i), onFavorite: () => toggleFavorite(i)))));
}

class HomePage extends StatelessWidget {
  final VoidCallback onBrowse, onSell;
  final Set<int> favorites;
  final void Function(int) onFavorite, onOpen;
  const HomePage({super.key, required this.onBrowse, required this.onSell, required this.favorites, required this.onFavorite, required this.onOpen});
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(16), children: [
    Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(gradient: const LinearGradient(colors: [brand, Color(0xFF16493D)]),borderRadius: BorderRadius.circular(24)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('ماشین بعدی‌ات\nاینجاست.', style: TextStyle(fontSize: 28, height: 1.4, color: Colors.white, fontWeight: FontWeight.w900)),
      const SizedBox(height: 8), const Text('خرید، فروش و اجاره خودرو در خوزستان', style: TextStyle(color: Colors.white70)),
      const SizedBox(height: 20), Row(children: [
        Expanded(child: FilledButton.icon(style: FilledButton.styleFrom(backgroundColor: Colors.white,foregroundColor: brand),onPressed: onBrowse, icon: const Icon(Icons.search),label: const Text('پیدا کردن خودرو'))),
        const SizedBox(width: 8), Expanded(child: OutlinedButton.icon(style: OutlinedButton.styleFrom(foregroundColor: Colors.white,side: const BorderSide(color: Colors.white60)),onPressed: onSell,icon: const Icon(Icons.add),label: const Text('ثبت آگهی'))),
      ])
    ])),
    const SizedBox(height: 22),
    const SectionTitle('دسته‌بندی‌ها','انتخاب سریع'),
    const SizedBox(height: 10),
    Row(children: const [
      CategoryTile(icon: Icons.directions_car, label: 'سواری'),
      CategoryTile(icon: Icons.local_shipping, label: 'وانت و باری'),
      CategoryTile(icon: Icons.two_wheeler, label: 'موتورسیکلت'),
      CategoryTile(icon: Icons.key, label: 'اجاره خودرو'),
    ]),
    const SizedBox(height: 22),
    SectionTitle('آگهی‌های تازه','مشاهده همه', action: onBrowse),
    const SizedBox(height: 10),
    ...List.generate(cars.length, (i) => CarTile(car: cars[i], favorite: favorites.contains(i), onFavorite: () => onFavorite(i), onTap: () => onOpen(i))),
    const SizedBox(height: 12),
    Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xFFE6F2EE),borderRadius: BorderRadius.circular(18)),child: const Row(children: [Icon(Icons.verified_user_outlined,color: brand,size: 30),SizedBox(width: 12),Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [Text('معامله مطمئن‌تر',style: TextStyle(fontWeight: FontWeight.bold,color: ink)),Text('قبل از پرداخت، خودرو و مدارک را بررسی کنید.',style: TextStyle(color: muted,fontSize: 12))]))])),
  ]);
}

class SectionTitle extends StatelessWidget {
  final String title, subtitle; final VoidCallback? action;
  const SectionTitle(this.title,this.subtitle,{super.key,this.action});
  @override Widget build(BuildContext context) => Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [Text(title,style: const TextStyle(fontWeight: FontWeight.w900,fontSize: 18,color: ink)),Text(subtitle,style: const TextStyle(fontSize: 12,color: muted))])),if(action!=null) TextButton(onPressed: action,child: const Text('مشاهده همه'))]);
}
class CategoryTile extends StatelessWidget {
  final IconData icon; final String label;
  const CategoryTile({super.key,required this.icon,required this.label});
  @override Widget build(BuildContext context) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 3),child: InkWell(onTap: (){},child: Container(padding: const EdgeInsets.symmetric(vertical: 14,horizontal: 4),decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(16)),child: Column(children: [Icon(icon,color: brand,size: 25),const SizedBox(height: 8),Text(label,style: const TextStyle(fontSize: 10,fontWeight: FontWeight.w700),textAlign: TextAlign.center)])))));
}
class CarTile extends StatelessWidget {
  final Car car; final bool favorite; final VoidCallback onFavorite,onTap;
  const CarTile({super.key,required this.car,required this.favorite,required this.onFavorite,required this.onTap});
  @override Widget build(BuildContext context) => Card(margin: const EdgeInsets.only(bottom: 10),child: InkWell(borderRadius: BorderRadius.circular(18),onTap: onTap,child: Padding(padding: const EdgeInsets.all(12),child: Row(children: [
    Container(width: 94,height: 94,decoration: BoxDecoration(color: const Color(0xFFEAF0EE),borderRadius: BorderRadius.circular(14)),child: Icon(car.icon,size: 44,color: brand)),
    const SizedBox(width: 12),Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [Text(car.title,style: const TextStyle(fontWeight: FontWeight.w900,fontSize: 15,color: ink)),const SizedBox(height: 7),Text('${car.year}  •  ${car.km} کیلومتر',style: const TextStyle(color: muted,fontSize: 12)),const SizedBox(height: 7),Text(car.price,style: const TextStyle(color: brand,fontWeight: FontWeight.w900)),const SizedBox(height: 5),Row(children: [const Icon(Icons.location_on_outlined,size: 14,color: muted),Text(car.city,style: const TextStyle(color: muted,fontSize: 11))])])),IconButton(onPressed: onFavorite,icon: Icon(favorite?Icons.favorite:Icons.favorite_border,color: favorite?Colors.red:muted))
  ]))));
}
class SearchPage extends StatefulWidget {
  final Set<int> favorites; final void Function(int) onFavorite,onOpen;
  const SearchPage({super.key,required this.favorites,required this.onFavorite,required this.onOpen});
  @override State<SearchPage> createState()=>_SearchPageState();
}
class _SearchPageState extends State<SearchPage>{
  String query=''; String city='همه شهرها';
  @override Widget build(BuildContext context){
    final filtered=List.generate(cars.length,(i)=>i).where((i)=>cars[i].title.contains(query)&& (city=='همه شهرها'||cars[i].city==city)).toList();
    return ListView(padding: const EdgeInsets.all(16),children:[
      const Text('جست‌وجوی خودرو',style: TextStyle(fontSize:23,fontWeight: FontWeight.w900,color:ink)),
      const SizedBox(height: 14),
      TextField(textDirection: TextDirection.rtl,decoration: InputDecoration(hintText:'نام خودرو را وارد کنید',prefixIcon:const Icon(Icons.search),filled:true,fillColor:Colors.white,border:OutlineInputBorder(borderRadius:BorderRadius.circular(16),borderSide:BorderSide.none)),onChanged:(v)=>setState(()=>query=v)),
      const SizedBox(height: 10),
      DropdownButtonFormField<String>(value:city,decoration:InputDecoration(labelText:'شهر',filled:true,fillColor:Colors.white,border:OutlineInputBorder(borderRadius:BorderRadius.circular(16),borderSide:BorderSide.none)),items:const ['همه شهرها','اهواز','آبادان','ماهشهر'].map((v)=>DropdownMenuItem(value:v,child:Text(v))).toList(),onChanged:(v)=>setState(()=>city=v??'همه شهرها')),
      const SizedBox(height: 16),Text('${filtered.length} آگهی',style:const TextStyle(color:muted)),
      ...filtered.map((i)=>CarTile(car:cars[i],favorite:widget.favorites.contains(i),onFavorite:()=>widget.onFavorite(i),onTap:()=>widget.onOpen(i))),
    ]);
  }
}
class CarDetailsPage extends StatelessWidget {
  final Car car; final bool favorite; final VoidCallback onFavorite;
  const CarDetailsPage({super.key,required this.car,required this.favorite,required this.onFavorite});
  @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('جزئیات خودرو')),body:ListView(padding:const EdgeInsets.all(16),children:[
    Container(height:210,decoration:BoxDecoration(color:const Color(0xFFE6EFEB),borderRadius:BorderRadius.circular(22)),child:Icon(car.icon,size:100,color:brand)),
    const SizedBox(height:18),Text(car.title,style:const TextStyle(fontSize:24,fontWeight:FontWeight.w900,color:ink)),
    const SizedBox(height:8),Text(car.price,style:const TextStyle(fontSize:20,fontWeight:FontWeight.w900,color:brand)),
    const SizedBox(height:16),Card(child:Column(children:[detailRow('مدل',car.year),detailRow('کارکرد','${car.km} کیلومتر'),detailRow('شهر',car.city),detailRow('نوع خودرو',car.type)])),
    const SizedBox(height:12),const Text('توضیحات فروشنده',style:TextStyle(fontSize:17,fontWeight:FontWeight.bold)),const SizedBox(height:6),const Text('این یک آگهی نمونه برای نمایش نسخه اولیه برنامه است. مشخصات و قیمت نهایی باید با فروشنده تأیید شود.',style:TextStyle(color:muted,height:1.6)),
    const SizedBox(height:18),Row(children:[Expanded(child:FilledButton.icon(onPressed:()=>ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('ارتباط با فروشنده در نسخه بعدی فعال می‌شود.'))),icon:const Icon(Icons.phone),label:const Text('تماس با فروشنده'))),const SizedBox(width:8),OutlinedButton.icon(onPressed:onFavorite,icon:Icon(favorite?Icons.favorite:Icons.favorite_border),label:const Text('نشان کردن'))])
  ]));
  Widget detailRow(String a,String b)=>Padding(padding:const EdgeInsets.symmetric(horizontal:14,vertical:12),child:Row(children:[Expanded(child:Text(a,style:const TextStyle(color:muted))),Text(b,style:const TextStyle(fontWeight:FontWeight.bold,color:ink))]));
}
class SellPage extends StatefulWidget { @override State<SellPage> createState()=>_SellPageState(); }
class _SellPageState extends State<SellPage>{
  final form=GlobalKey<FormState>(); final title=TextEditingController(); final price=TextEditingController(); final phone=TextEditingController(); String city='اهواز'; String kind='فروش';
  @override Widget build(BuildContext context)=>ListView(padding:const EdgeInsets.all(16),children:[
    const Text('ثبت آگهی خودرو',style:TextStyle(fontSize:23,fontWeight:FontWeight.w900,color:ink)),const SizedBox(height:6),const Text('اطلاعات خودرو را وارد کنید؛ این نسخه فعلاً آزمایشی است.',style:TextStyle(color:muted)),
    const SizedBox(height:16),Form(key:form,child:Column(children:[
      field(title,'عنوان آگهی، مثلاً پژو ۲۰۷'),const SizedBox(height:12),field(price,'قیمت به تومان',keyboard:TextInputType.number),const SizedBox(height:12),field(phone,'شماره تماس',keyboard:TextInputType.phone),const SizedBox(height:12),
      DropdownButtonFormField<String>(value:kind,decoration:dec('نوع آگهی'),items:const ['فروش','اجاره'].map((v)=>DropdownMenuItem(value:v,child:Text(v))).toList(),onChanged:(v)=>setState(()=>kind=v??'فروش')),
      const SizedBox(height:12),DropdownButtonFormField<String>(value:city,decoration:dec('شهر'),items:const ['اهواز','آبادان','ماهشهر','دزفول','خرمشهر'].map((v)=>DropdownMenuItem(value:v,child:Text(v))).toList(),onChanged:(v)=>setState(()=>city=v??'اهواز')),
      const SizedBox(height:18),Container(width:double.infinity,padding:const EdgeInsets.all(18),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(16)),child:const Column(children:[Icon(Icons.add_a_photo_outlined,size:32,color:brand),SizedBox(height:6),Text('افزودن عکس خودرو در نسخه بعدی فعال می‌شود',textAlign:TextAlign.center,style:TextStyle(color:muted))])),
      const SizedBox(height:18),SizedBox(width:double.infinity,child:FilledButton(onPressed:(){if(form.currentState!.validate()){showDialog(context:context,builder:(_)=>AlertDialog(title:const Text('اطلاعات ثبت شد'),content:Text('آگهی «${title.text}» به‌صورت نمایشی آماده شد. برای انتشار واقعی، اتصال سرور لازم است.'),actions:[TextButton(onPressed:()=>Navigator.pop(context),child:const Text('متوجه شدم'))]));}},child:const Padding(padding:EdgeInsets.all(14),child:Text('ادامه ثبت آگهی'))))
    ]))
  ]);
  InputDecoration dec(String label)=>InputDecoration(labelText:label,filled:true,fillColor:Colors.white,border:OutlineInputBorder(borderRadius:BorderRadius.circular(14),borderSide:BorderSide.none));
  Widget field(TextEditingController c,String hint,{TextInputType keyboard=TextInputType.text})=>TextFormField(controller:c,keyboardType:keyboard,decoration:dec(hint),validator:(v)=>(v==null||v.trim().isEmpty)?'این فیلد را تکمیل کنید':null);
}
class FavoritesPage extends StatelessWidget {
  final Set<int> favorites;final void Function(int) onFavorite,onOpen;
  const FavoritesPage({super.key,required this.favorites,required this.onFavorite,required this.onOpen});
  @override Widget build(BuildContext context){final ids=favorites.toList();return ListView(padding:const EdgeInsets.all(16),children:[const Text('آگهی‌های نشان‌شده',style:TextStyle(fontSize:23,fontWeight:FontWeight.w900,color:ink)),const SizedBox(height:12),if(ids.isEmpty)const Padding(padding:EdgeInsets.all(35),child:Column(children:[Icon(Icons.favorite_border,size:50,color:muted),SizedBox(height:10),Text('هنوز آگهی‌ای نشان نکرده‌اید',style:TextStyle(color:muted))])),...ids.map((i)=>CarTile(car:cars[i],favorite:true,onFavorite:()=>onFavorite(i),onTap:()=>onOpen(i)))]);}
}
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override Widget build(BuildContext context)=>ListView(padding:const EdgeInsets.all(16),children:[
    const Text('حساب کاربری',style:TextStyle(fontSize:23,fontWeight:FontWeight.w900,color:ink)),const SizedBox(height:16),
    Container(padding:const EdgeInsets.all(20),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(20)),child:const Column(children:[CircleAvatar(radius:34,backgroundColor:Color(0xFFE4F1EC),child:Icon(Icons.person_outline,size:36,color:brand)),SizedBox(height:10),Text('مهمان',style:TextStyle(fontWeight:FontWeight.w900,fontSize:18)),Text('برای استفاده از امکانات حساب، ورود در نسخه بعدی اضافه می‌شود.',textAlign:TextAlign.center,style:TextStyle(color:muted))])),
    const SizedBox(height:14),for(final item in const [('ورود و ثبت‌نام',Icons.login),('آگهی‌های من',Icons.directions_car_outlined),('پشتیبانی',Icons.support_agent),('درباره کاربای خودرو',Icons.info_outline)]) Card(child:ListTile(leading:Icon(item.$2,color:brand),title:Text(item.$1),trailing:const Icon(Icons.chevron_left),onTap:()=>ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('این بخش در نسخه بعدی تکمیل می‌شود.')))))
  ]);
}
