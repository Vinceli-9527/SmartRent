import { router } from '@kit.ArkUI';
import { SearchBar } from '../components/SearchBar';
import { NavList } from '../components/NavList';
import { TileList } from '../components/TileList';
import { PlanList } from '../components/PlanList';
import { Ad } from '../components/Ad';
import { RoomRecommend } from '../components/RoomRecommend';
import { QuickEntry } from '../model/HomeData';
import { RoomRecommendData } from '../model/RoomRecommendData';
import { TileItem } from '../model/TileData';
import { PlanStep } from '../model/PlanData';

/**
 * 组件展示页 — 5.3~5.8 各组件的独立示例
 */
@Entry
@Component
struct DemoPage {
  // Ad 示例数据
  private adBanners: Array<string | Resource> = [
    $r('app.media.sr_banner_01'),
    $r('app.media.sr_banner_02'),
    $r('app.media.sr_banner_03')
  ];

  // NavList 示例数据
  private navItems: QuickEntry[] = [];

  // TileList 示例数据
  private tileItems: TileItem[] = [];

  // PlanList 示例数据
  private planSteps: PlanStep[] = [];

  // RoomRecommend 示例数据
  private roomList: RoomRecommendData[] = [];

  aboutToAppear() {
    this.buildNavData();
    this.buildTileData();
    this.buildPlanData();
    this.buildRoomData();
  }

  buildNavData() {
    const q1 = new QuickEntry();
    q1.icon = $r('app.media.ic_home_search');
    q1.name = '找房';
    q1.route = '';
    this.navItems.push(q1);

    const q2 = new QuickEntry();
    q2.icon = $r('app.media.ic_service_default');
    q2.name = '签约';
    q2.route = '';
    this.navItems.push(q2);

    const q3 = new QuickEntry();
    q3.icon = $r('app.media.ic_my_order');
    q3.name = '我的';
    q3.route = '';
    this.navItems.push(q3);

    const q4 = new QuickEntry();
    q4.icon = $r('app.media.ic_tab_discover');
    q4.name = '发现';
    q4.route = '';
    this.navItems.push(q4);
  }

  buildTileData() {
    const s1 = new TileItem();
    s1.title = '在线报修';
    s1.subtitle = '快速响应';
    s1.icon = $r('app.media.ic_service_default');
    this.tileItems.push(s1);

    const s2 = new TileItem();
    s2.title = '保洁服务';
    s2.subtitle = '专业清洁';
    s2.icon = $r('app.media.ic_service_default');
    this.tileItems.push(s2);

    const s3 = new TileItem();
    s3.title = '搬家服务';
    s3.subtitle = '省心省力';
    s3.icon = $r('app.media.ic_service_default');
    this.tileItems.push(s3);

    const s4 = new TileItem();
    s4.title = '宽带办理';
    s4.subtitle = '极速上网';
    s4.icon = $r('app.media.ic_service_default');
    this.tileItems.push(s4);

    const s5 = new TileItem();
    s5.title = '水电缴费';
    s5.subtitle = '一键搞定';
    s5.icon = $r('app.media.ic_service_default');
    this.tileItems.push(s5);

    const s6 = new TileItem();
    s6.title = '退租服务';
    s6.subtitle = '便捷退租';
    s6.icon = $r('app.media.ic_service_default');
    this.tileItems.push(s6);
  }

  buildPlanData() {
    const p1 = new PlanStep();
    p1.title = '在线选房';
    p1.desc = '浏览海量房源，根据位置、价格、户型筛选心仪好房';
    this.planSteps.push(p1);

    const p2 = new PlanStep();
    p2.title = '预约看房';
    p2.desc = '选择方便的时间段，一键预约，房东确认后即可看房';
    this.planSteps.push(p2);

    const p3 = new PlanStep();
    p3.title = '实地考察';
    p3.desc = '房东或管家带看，实地了解房屋采光、设施、周边环境';
    this.planSteps.push(p3);

    const p4 = new PlanStep();
    p4.title = '签约入住';
    p4.desc = '确认房源后在线签订电子合同，支付押金即可安心入住';
    this.planSteps.push(p4);
  }

  buildRoomData() {
    const r1 = new RoomRecommendData();
    r1.id = 'demo1';
    r1.title = '阳光花园精装两居室';
    r1.price = 3200;
    r1.area = 85;
    r1.roomType = '2室1厅';
    r1.floor = '中楼层/18层';
    r1.address = '朝阳区阳光花园12号楼';
    r1.isNew = true;
    r1.tags = ['近地铁', '精装修', '随时看'];
    r1.coverUrl = $r('app.media.sr_room_05');
    this.roomList.push(r1);

    const r2 = new RoomRecommendData();
    r2.id = 'demo2';
    r2.title = '翠苑新村温馨一居';
    r2.price = 2200;
    r2.area = 45;
    r2.roomType = '1室1厅';
    r2.floor = '低楼层/6层';
    r2.address = '海淀区翠苑新村3栋';
    r2.isNew = false;
    r2.tags = ['采光好', '家电齐全'];
    r2.coverUrl = $r('app.media.sr_room_06');
    this.roomList.push(r2);

    const r3 = new RoomRecommendData();
    r3.id = 'demo3';
    r3.title = '朗诗国际大三房';
    r3.price = 5500;
    r3.area = 120;
    r3.roomType = '3室2厅';
    r3.floor = '高楼层/33层';
    r3.address = '浦东新区朗诗国际8栋';
    r3.isNew = true;
    r3.tags = ['江景房', '豪华装修', '拎包入住'];
    r3.coverUrl = $r('app.media.sr_room_07');
    this.roomList.push(r3);
  }

  build() {
    Column() {
      // Nav bar
      Row() {
        Image($r('app.media.ic_back'))
          .width(24).height(24)
          .onClick(() => { router.back() })
        Text('组件展示（5.3~5.8）')
          .fontSize(17)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
        Row().width(24).height(24)
      }
      .width('100%').height(44).padding({ left: 16, right: 16 }).backgroundColor('#FFFFFF')

      Scroll() {
        Column() {
          // 5.3 SearchBar
          this.SectionTitle('5.3 SearchBar 搜索栏')
          SearchBar({
            placeholder: '搜索小区、商圈、地铁',
            showMsg: true,
            onSearch: () => {},
            onMsg: () => { router.pushUrl({ url: 'pages/MessagePage' }) }
          })
          .margin({ bottom: 12 })

          // 5.4 NavList
          this.SectionTitle('5.4 NavList 快捷导航')
          NavList({
            items: this.navItems,
            columns: 4
          })
          .margin({ bottom: 12 })

          // 5.5 TileList
          this.SectionTitle('5.5 TileList 服务磁贴')
          TileList({
            items: this.tileItems,
            columns: 3,
            showSubtitle: true
          })
          .margin({ bottom: 12 })

          // 5.6 PlanList
          this.SectionTitle('5.6 PlanList 步骤列表')
          PlanList({
            steps: this.planSteps,
            title: '看房流程'
          })
          .margin({ bottom: 12 })

          // 5.7 Ad
          this.SectionTitle('5.7 Ad 轮播广告')
          Ad({
            banners: this.adBanners,
            bannerHeight: 120,
            autoPlay: true,
            interval: 2500
          })
          .margin({ bottom: 12 })

          // 5.8 RoomRecommend
          this.SectionTitle('5.8 RoomRecommend 房源推荐')
          RoomRecommend({
            list: this.roomList,
            title: '精品推荐',
            loading: false,
            hasMore: false
          })

          // 底部留白
          Column().width('100%').height(40)
        }
        .width('100%')
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .width('100%').height('100%').backgroundColor('#F5F5F5')
  }

  @Builder SectionTitle(text: string) {
    Row() {
      Text(text)
        .fontSize(13)
        .fontWeight(FontWeight.Bold)
        .fontColor('#FFFFFF')
        .padding({ left: 10, right: 10, top: 4, bottom: 4 })
        .borderRadius(4)
        .backgroundColor('#1677FF')
    }
    .width('100%')
    .padding({ left: 16, top: 16, bottom: 4 })
  }
}
