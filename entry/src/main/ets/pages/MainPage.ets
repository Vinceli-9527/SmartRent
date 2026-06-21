import { HomeApi } from '../api/HomeApi';
import { HomeData, BannerData } from '../model/HomeData';
import { RoomRecommendData } from '../model/RoomRecommendData';
import { UserData } from '../model/UserData';
import { ServiceApi } from '../api/ServiceApi';
import { ServiceData, ServiceItem } from '../model/ServiceData';
import { DiscoverApi } from '../api/DiscoverApi';
import { DiscoverData, DiscoverArticle } from '../model/DiscoverData';
import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';

import { SearchBar } from '../components/SearchBar';
import { TileList } from '../components/TileList';
import { PlanList } from '../components/PlanList';
import { Ad } from '../components/Ad';
import { RoomRecommend } from '../components/RoomRecommend';
import { TileItem } from '../model/TileData';
import { PlanStep } from '../model/PlanData';
import { TagEntry } from '../model/TagEntryData';
import { PersonaPlan } from '../model/PersonaPlanData';

@Entry
@Component
struct MainPage {
  @State currentTab: number = 0
  @State homeRefreshing: boolean = false
  @State homeData: HomeData = new HomeData()
  @State recommendList: RoomRecommendData[] = []
  @State recommendLoading: boolean = false
  @State recommendHasMore: boolean = true
  @State recommendPage: number = 1
  @State services: ServiceData = new ServiceData()
  @State discoverData: DiscoverData = new DiscoverData()
  @State userInfo: UserData = new UserData()
  @State bannerUrls: Array<string | Resource> = []
  @State tileItems: TileItem[] = []
  @State planSteps: PlanStep[] = []
  @State searchKeyword: string = ''
  @State tagEntries: TagEntry[] = []
  @State personaPlans: PersonaPlan[] = []
  @State favoriteIds: string[] = []
  @State favoriteItems: RoomRecommendData[] = []
  @State commuteDestination: string = '望京 SOHO'
  @State commuteDraft: string = '望京 SOHO'
  @State destinationDialogVisible: boolean = false
  @State serviceAddress: string = '阳光花园 12 号楼'
  @State serviceAddressDraft: string = '阳光花园 12 号楼'
  @State serviceAddressDialogVisible: boolean = false
  @State discoverRefreshing: boolean = false

  private tabs: string[] = ['首页', '想看', '服务', '发现', '我的']
  private primaryColor: string = '#2E6FDC'

  aboutToAppear() {
    this.loadHomeData();
    this.initServiceData();
    this.initTagEntries();
    this.initPersonaPlans();
  }

  refreshHome() {
    this.homeRefreshing = true;
    this.recommendPage = 1;
    this.recommendHasMore = true;
    this.loadHomeData();
    setTimeout(() => {
      this.homeRefreshing = false;
    }, 800);
  }

  loadHomeData() {
    HomeApi.getHomeData().then((res) => {
      if (res.code === 0 && res.data) {
        this.homeData = res.data;
        const urls: Array<string | Resource> = [];
        this.homeData.banners.forEach((b: BannerData) => {
          urls.push(b.imageUrl);
        });
        this.bannerUrls = urls.length > 0 ? urls : this.getFallbackBanners();
      } else {
        this.fallbackHomeData();
      }
    }).catch(() => {
      this.fallbackHomeData();
    });
    this.loadRecommend(true);
  }

  getFallbackBanners(): Array<string | Resource> {
    return [
      $r('app.media.sr_banner_01'),
      $r('app.media.sr_banner_02'),
      $r('app.media.sr_banner_03')
    ];
  }

  fallbackHomeData() {
    this.bannerUrls = this.getFallbackBanners();
  }

  loadRecommend(refresh: boolean) {
    if (this.recommendLoading) return;
    if (!refresh && !this.recommendHasMore) return;
    this.recommendLoading = true;
    const page = refresh ? 1 : this.recommendPage;
    HomeApi.getRecommendList(page, 10).then((res) => {
      this.recommendLoading = false;
      if (res.code === 0 && res.data) {
        this.recommendList = refresh ? res.data : this.recommendList.concat(res.data);
        this.recommendHasMore = res.data.length >= 10;
        if (!refresh && res.data.length > 0) this.recommendPage++;
      } else {
        this.fallbackRecommend();
      }
    }).catch(() => {
      this.fallbackRecommend();
    });
  }

  fallbackRecommend() {
    this.recommendLoading = false;
    if (this.recommendList.length > 0) return;
    const list: RoomRecommendData[] = [];
    const d1 = new RoomRecommendData();
    d1.id = '0'; d1.title = '阳光花园精装两居室'; d1.price = 3200; d1.area = 85;
    d1.roomType = '2室1厅'; d1.floor = '中楼层/18层'; d1.address = '朝阳区阳光花园2号楼';
    d1.isNew = true; d1.tags = ['近地铁', '精装修']; d1.coverUrl = $r('app.media.sr_room_01');
    list.push(d1);
    const d2 = new RoomRecommendData();
    d2.id = '1'; d2.title = '翠苑新村温馨一居'; d2.price = 2200; d2.area = 45;
    d2.roomType = '1室1厅'; d2.floor = '低楼层/6层'; d2.address = '海淀区翠苑新村3栋';
    d2.tags = ['采光好', '家电齐全']; d2.coverUrl = $r('app.media.sr_room_02');
    list.push(d2);
    const d3 = new RoomRecommendData();
    d3.id = '2'; d3.title = '朗诗国际大三房'; d3.price = 5500; d3.area = 120;
    d3.roomType = '3室2厅'; d3.floor = '高楼层/33层'; d3.address = '浦东新区朗诗国际8栋';
    d3.isNew = true; d3.tags = ['江景房', '品质社区']; d3.coverUrl = $r('app.media.sr_room_03');
    list.push(d3);
    const d4 = new RoomRecommendData();
    d4.id = '3'; d4.title = '城市花园小户型公寓'; d4.price = 1800; d4.area = 35;
    d4.roomType = '1室'; d4.floor = '中楼层/12层'; d4.address = '朝阳区万科城市花园';
    d4.tags = ['整租', '拎包入住']; d4.coverUrl = $r('app.media.sr_room_04');
    list.push(d4);
    this.recommendList = list;
    this.recommendHasMore = false;
  }

  initTagEntries() {
    const items: TagEntry[] = [];
    const e1 = new TagEntry(); e1.id = '1'; e1.icon = $r('app.media.ic_home_search');
    e1.title = '整租好房'; e1.subtitle = '独立空间'; e1.tag = '整租'; e1.color = this.primaryColor;
    items.push(e1);
    const e2 = new TagEntry(); e2.id = '2'; e2.icon = $r('app.media.ic_location');
    e2.title = '近地铁'; e2.subtitle = '通勤省时'; e2.tag = '近地铁'; e2.color = this.primaryColor;
    items.push(e2);
    const e3 = new TagEntry(); e3.id = '3'; e3.icon = $r('app.media.ic_service_default');
    e3.title = '精装修'; e3.subtitle = '拎包入住'; e3.tag = '精装修'; e3.color = this.primaryColor;
    items.push(e3);
    const e4 = new TagEntry(); e4.id = '4'; e4.icon = $r('app.media.ic_my_coupon');
    e4.title = '低价好房'; e4.subtitle = '预算友好'; e4.tag = '1000-3000'; e4.color = this.primaryColor;
    items.push(e4);
    this.tagEntries = items;
  }

  initPersonaPlans() {
    this.personaPlans = [
      this.createPersona('在校生', '校园周边优选', $r('app.media.ic_persona_student')),
      this.createPersona('毕业生', '首租安心方案', $r('app.media.ic_persona_graduate')),
      this.createPersona('打工人', '通勤效率优先', $r('app.media.ic_persona_worker')),
      this.createPersona('外籍人士', '双语服务支持', $r('app.media.ic_persona_foreigner'))
    ];
  }

  createPersona(name: string, desc: string, icon: Resource): PersonaPlan {
    const plan = new PersonaPlan();
    plan.personaName = name;
    plan.personaDesc = desc;
    plan.personaIcon = icon;
    plan.color = this.primaryColor;
    const s1 = new PlanStep(); s1.title = '明确预算'; s1.desc = '确认租金上限和必要配置';
    const s2 = new PlanStep(); s2.title = '筛选区域'; s2.desc = '按通勤、社区和生活便利度缩小范围';
    const s3 = new PlanStep(); s3.title = '预约看房'; s3.desc = '集中预约，减少无效往返';
    const s4 = new PlanStep(); s4.title = '签约入住'; s4.desc = '确认合同、押金和入住清单';
    plan.steps = [s1, s2, s3, s4];
    return plan;
  }

  initServiceData() {
    ServiceApi.getServices().then((res) => {
      if (res.code === 0 && res.data) {
        this.services = res.data;
        const items: TileItem[] = [];
        this.services.services.forEach((s: ServiceItem) => {
          const t = new TileItem();
          t.id = s.route; t.icon = s.icon; t.title = s.name; t.subtitle = s.desc;
          items.push(t);
        });
        this.tileItems = items;
      }
    });

    const steps: PlanStep[] = [];
    const s1 = new PlanStep(); s1.title = '在线选房'; s1.desc = '按预算、区域和户型筛选合适房源'; steps.push(s1);
    const s2 = new PlanStep(); s2.title = '预约看房'; s2.desc = '选择时间段，一键预约实地看房'; steps.push(s2);
    const s3 = new PlanStep(); s3.title = '实地考察'; s3.desc = '确认采光、配置和周边环境'; steps.push(s3);
    const s4 = new PlanStep(); s4.title = '签约入住'; s4.desc = '确认合同后安心入住'; steps.push(s4);
    this.planSteps = steps;

    DiscoverApi.getDiscoverList(1).then((res) => {
      if (res.code === 0 && res.data) this.discoverData = res.data;
    });
  }

  toggleFavorite(item: RoomRecommendData) {
    const idx = this.favoriteIds.indexOf(item.id);
    if (idx >= 0) {
      this.favoriteIds.splice(idx, 1);
      const fi = this.favoriteItems.findIndex((f: RoomRecommendData) => f.id === item.id);
      if (fi >= 0) this.favoriteItems.splice(fi, 1);
      promptAction.showToast({ message: '已取消收藏' });
    } else {
      this.favoriteIds.push(item.id);
      const copy = new RoomRecommendData();
      copy.id = item.id; copy.title = item.title; copy.price = item.price; copy.area = item.area;
      copy.roomType = item.roomType; copy.floor = item.floor; copy.address = item.address;
      copy.coverUrl = item.coverUrl; copy.tags = item.tags; copy.isNew = item.isNew;
      this.favoriteItems.push(copy);
      promptAction.showToast({ message: '已收藏' });
    }
  }

  onBannerClick(index: number) {
    const banner = this.homeData.banners[index];
    if (banner && banner.linkType === 'house' && banner.linkValue) {
      router.pushUrl({ url: 'pages/RentDetailPage', params: { 'id': banner.linkValue } });
    }
  }

  onTileClick(item: TileItem) {
    if (item.id) router.pushUrl({ url: item.id });
  }

  getFilteredList(): RoomRecommendData[] {
    if (!this.searchKeyword) return this.recommendList;
    const kw = this.searchKeyword.toLowerCase();
    const result: RoomRecommendData[] = [];
    this.recommendList.forEach((item: RoomRecommendData) => {
      if (item.title.toLowerCase().indexOf(kw) >= 0 ||
          item.address.toLowerCase().indexOf(kw) >= 0 ||
          item.roomType.toLowerCase().indexOf(kw) >= 0) {
        result.push(item);
      }
    });
    return result;
  }

  getAverageFavoriteRent(): number {
    if (this.favoriteItems.length === 0) return 0;
    let total = 0;
    this.favoriteItems.forEach((item: RoomRecommendData) => {
      total += item.price;
    });
    return Math.round(total / this.favoriteItems.length);
  }

  getLatestFavoriteTitle(): string {
    if (this.favoriteItems.length === 0) return '暂无最近收藏';
    return this.favoriteItems[this.favoriteItems.length - 1].title;
  }

  openDestinationDialog() {
    this.commuteDraft = this.commuteDestination;
    this.destinationDialogVisible = true;
  }

  confirmDestination() {
    const value = this.commuteDraft.trim();
    if (value.length === 0) {
      promptAction.showToast({ message: '请输入通勤目的地' });
      return;
    }
    this.commuteDestination = value;
    this.destinationDialogVisible = false;
    promptAction.showToast({ message: '通勤目的地已更新' });
  }

  getCommuteParams(): Record<string, Object> {
    const params: Record<string, Object> = {};
    params['destination'] = this.commuteDestination;
    params['favoriteCount'] = this.favoriteItems.length;
    params['latestFavoriteTitle'] = this.getLatestFavoriteTitle();
    params['averageRent'] = this.getAverageFavoriteRent();
    params['source'] = 'favorite';
    return params;
  }

  goCommuteSearch() {
    const params = this.getCommuteParams();
    params['mode'] = 'commute';
    params['action'] = 'filter';
    router.pushUrl({ url: 'pages/RentListPage', params: params });
  }

  goMapSearch(scene: string = 'map') {
    const params = this.getCommuteParams();
    params['mode'] = 'map';
    params['scene'] = scene;
    router.pushUrl({ url: 'pages/MapSearchPage', params: params });
  }

  goTripPage() {
    router.pushUrl({ url: 'pages/TripPage', params: this.getCommuteParams() });
  }

  openServiceAddressDialog() {
    this.serviceAddressDraft = this.serviceAddress;
    this.serviceAddressDialogVisible = true;
  }

  confirmServiceAddress() {
    if (this.serviceAddressDraft.trim().length === 0) {
      promptAction.showToast({ message: '请选择服务地址' });
      return;
    }
    this.serviceAddress = this.serviceAddressDraft;
    this.serviceAddressDialogVisible = false;
    promptAction.showToast({ message: '服务地址已更新' });
  }

  showServiceToast(title: string) {
    promptAction.showToast({ message: `${title} 服务暂未接入` });
  }

  goVipDetail() {
    router.pushUrl({
      url: 'pages/VipDetailPage',
      params: {
        'level': '黄金会员',
        'validUntil': '2026.12.31',
        'address': this.serviceAddress
      }
    });
  }

  refreshDiscover() {
    this.discoverRefreshing = true;
    setTimeout(() => {
      this.discoverRefreshing = false;
      promptAction.showToast({ message: '发现内容已更新' });
    }, 800);
  }

  goArticleDetail(title: string, summary: string, cover: Resource, tag: string) {
    router.pushUrl({
      url: 'pages/ArticleDetailPage',
      params: {
        'title': title,
        'summary': summary,
        'tag': tag,
        'cover': cover
      }
    });
  }

  goDiscoverAdPage() {
    router.pushUrl({ url: 'pages/DiscoverAdPage' });
  }

  @Builder HomeTab() {
    Refresh({ refreshing: $$this.homeRefreshing }) {
      Scroll() {
        Column() {
          Row() {
            Column() {
              Text('今天想住在哪里？')
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .fontColor('#202733')
              Text('为你快速匹配舒适、可靠的房源')
                .fontSize(12)
                .fontColor('#8A94A6')
                .margin({ top: 3 })
            }
            .alignItems(HorizontalAlign.Start)
          }
          .width('100%')
          .padding({ left: 20, right: 20, top: 12, bottom: 4 })

          SearchBar({
            placeholder: '搜索小区、商圈、地铁',
            showMsg: !this.searchKeyword.length,
            editable: true,
            searchText: this.searchKeyword,
            onChange: (value: string) => { this.searchKeyword = value },
            onMsg: () => { router.pushUrl({ url: 'pages/MessagePage' }) }
          })

          if (this.searchKeyword.length === 0) {
            if (this.bannerUrls.length > 0) {
              Ad({
                banners: this.bannerUrls,
                bannerHeight: 164,
                autoPlay: true,
                radius: 18,
                onBannerClick: (index: number) => { this.onBannerClick(index) }
              })
              .margin({ bottom: 22 })
            }

            this.SectionTitle('快速找房', '按真实需求快速筛选')
            Grid() {
              ForEach(this.tagEntries, (item: TagEntry) => {
                GridItem() {
                  this.EntryCard(item.icon, item.title, item.subtitle, () => {
                    router.pushUrl({ url: 'pages/RentListPage', params: { 'tag': item.tag } });
                  })
                }
              }, (item: TagEntry) => item.id)
            }
            .columnsTemplate('1fr 1fr')
            .columnsGap(12)
            .rowsGap(12)
            .padding({ left: 20, right: 20 })
            .margin({ bottom: 24 })

            this.SectionTitle('为你定制', '不同人群的租房路径')
            Grid() {
              ForEach(this.personaPlans, (plan: PersonaPlan) => {
                GridItem() {
                  this.EntryCard(plan.personaIcon, plan.personaName, plan.personaDesc, () => {
                    const params: Record<string, Object> = {};
                    params['personaName'] = plan.personaName;
                    params['personaDesc'] = plan.personaDesc;
                    params['personaColor'] = plan.color;
                    params['stepCount'] = plan.steps.length;
                    plan.steps.forEach((s: PlanStep, i: number) => {
                      params[`stepTitle${i}`] = s.title;
                      params[`stepDesc${i}`] = s.desc;
                    });
                    router.pushUrl({ url: 'pages/PersonaPlanDetailPage', params: params });
                  })
                }
              }, (plan: PersonaPlan) => plan.personaName)
            }
            .columnsTemplate('1fr 1fr')
            .columnsGap(12)
            .rowsGap(12)
            .padding({ left: 20, right: 20 })
            .margin({ bottom: 24 })

            Row() {
              Column() {
                Text('有闲置房源？')
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#202733')
                Text('提交房源信息，我们协助高效出租')
                  .fontSize(12)
                  .fontColor('#667085')
                  .margin({ top: 4 })
              }
              .alignItems(HorizontalAlign.Start)
              .layoutWeight(1)
              Text('发布房源')
                .fontSize(12)
                .fontColor('#FFFFFF')
                .padding({ left: 14, right: 14, top: 7, bottom: 7 })
                .backgroundColor(this.primaryColor)
                .borderRadius(14)
            }
            .width('100%')
            .height(74)
            .padding({ left: 18, right: 14 })
            .backgroundColor('#F0F6FF')
            .borderRadius(18)
            .margin({ left: 20, right: 20, bottom: 24 })
            .onClick(() => { router.pushUrl({ url: 'pages/LandlordPage' }) })

            RoomRecommend({
              list: this.recommendList,
              title: '为你推荐',
              loading: this.recommendLoading,
              hasMore: this.recommendHasMore,
              onLoadMore: () => { this.loadRecommend(false) },
              onRefresh: () => { this.loadRecommend(true) },
              onFavorite: (item: RoomRecommendData) => { this.toggleFavorite(item) },
              favoriteIds: this.favoriteIds
            })
          } else {
            Text('搜索结果')
              .fontSize(15)
              .fontColor('#8A94A6')
              .width('100%')
              .padding({ left: 20, top: 8, bottom: 8 })
            RoomRecommend({
              list: this.getFilteredList(),
              title: '',
              loading: false,
              hasMore: false,
              onFavorite: (item: RoomRecommendData) => { this.toggleFavorite(item) },
              favoriteIds: this.favoriteIds
            })
          }
        }
        .width('100%')
        .padding({ bottom: 20 })
      }
      .width('100%')
      .height('100%')
      .scrollBar(BarState.Off)
    }
    .onRefreshing(() => {
      this.refreshHome();
    })
    .width('100%')
    .height('100%')
  }

  @Builder SectionTitle(title: string, subtitle: string) {
    Row() {
      Column() {
        Text(title)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#202733')
        Text(subtitle)
          .fontSize(12)
          .fontColor('#8A94A6')
          .margin({ top: 2 })
      }
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .padding({ left: 20, right: 20, bottom: 12 })
  }

  @Builder EntryCard(icon: Resource, title: string, subtitle: string, onClick: () => void) {
    Row() {
      Row() {
        Image(icon)
          .width(27)
          .height(27)
          .fillColor(this.primaryColor)
      }
      .width(46)
      .height(46)
      .borderRadius(14)
      .backgroundColor('#F2F6FC')
      .justifyContent(FlexAlign.Center)

      Column() {
        Text(title)
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor('#202733')
          .maxLines(1)
        Text(subtitle)
          .fontSize(11)
          .fontColor('#8A94A6')
          .maxLines(1)
          .margin({ top: 3 })
      }
      .alignItems(HorizontalAlign.Start)
      .margin({ left: 10 })
      .layoutWeight(1)
    }
    .width('100%')
    .height(80)
    .padding({ left: 12, right: 12 })
    .backgroundColor('#FFFFFF')
    .borderRadius(18)
    .shadow({ radius: 14, color: '#16000000', offsetX: 0, offsetY: 7 })
    .onClick(onClick)
  }

  @Builder FavoriteTab() {
    Column() {
      this.SimpleHeader('想看')
      if (this.favoriteItems.length > 0) {
        RoomRecommend({
          list: this.favoriteItems,
          title: '',
          loading: false,
          hasMore: false,
          favoriteIds: this.favoriteIds,
          onFavorite: (item: RoomRecommendData) => { this.toggleFavorite(item) }
        })
      } else {
        this.EmptyState('还没有收藏房源', '去首页看看心仪的房子')
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F6F8FB')
  }

  @Builder FavoriteTabV2() {
    Stack() {
      Column()
        .width('100%')
        .height('100%')
        .linearGradient({
          direction: GradientDirection.Bottom,
          colors: [['#EEF6FF', 0.0], ['#F7FAFE', 0.48], ['#FFFFFF', 1.0]]
        })

      Scroll() {
        Column() {
          this.FavoriteNavBar()
          this.FindRoom()
          this.FavoriteSummary()

          if (this.favoriteItems.length > 0) {
            Row() {
              Text('最近收藏')
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .fontColor('#202733')
              Blank()
              Text(`${this.favoriteItems.length} 套`)
                .fontSize(12)
                .fontColor('#8A94A6')
            }
            .width('100%')
            .padding({ left: 20, right: 20, top: 8, bottom: 12 })

            RoomRecommend({
              list: this.favoriteItems,
              title: '',
              loading: false,
              hasMore: false,
              favoriteIds: this.favoriteIds,
              onFavorite: (item: RoomRecommendData) => { this.toggleFavorite(item) }
            })
          } else {
            this.FavoriteEmptyState()
          }
        }
        .width('100%')
        .padding({ bottom: 24 })
      }
      .width('100%')
      .height('100%')
      .scrollBar(BarState.Off)

      if (this.destinationDialogVisible) {
        this.DestinationDialog()
      }
    }
    .width('100%')
    .height('100%')
  }

  @Builder FavoriteNavBar() {
    Row() {
      Column() {
        Text('通勤目的地')
          .fontSize(11)
          .fontColor('#6D7B8F')
        Row() {
          Image($r('app.media.ic_location'))
            .width(16)
            .height(16)
            .fillColor(this.primaryColor)
            .margin({ right: 5 })
          Text(this.commuteDestination)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#202733')
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
          Image($r('app.media.ic_arrow_right'))
            .width(14)
            .height(14)
            .fillColor('#8A94A6')
            .margin({ left: 2 })
        }
        .margin({ top: 4 })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
      .onClick(() => { this.openDestinationDialog() })

      this.NavIconButton($r('app.media.ic_msg'), () => {
        router.pushUrl({ url: 'pages/MessagePage' });
      }, true)
      this.NavIconButton($r('app.media.ic_trip'), () => {
        this.goTripPage();
      }, false)
    }
    .width('100%')
    .height(82)
    .padding({ left: 20, right: 20, top: 14, bottom: 10 })
  }

  @Builder NavIconButton(icon: Resource, onClick: () => void, unread: boolean) {
    Stack({ alignContent: Alignment.TopEnd }) {
      Row() {
        Image(icon)
          .width(21)
          .height(21)
          .fillColor(this.primaryColor)
      }
      .width(42)
      .height(42)
      .borderRadius(16)
      .backgroundColor('#FFFFFF')
      .justifyContent(FlexAlign.Center)
      .shadow({ radius: 12, color: '#12000000', offsetX: 0, offsetY: 6 })

      if (unread) {
        Circle()
          .width(7)
          .height(7)
          .fill('#E85D6A')
          .margin({ top: 7, right: 7 })
      }
    }
    .width(42)
    .height(42)
    .margin({ left: 10 })
    .onClick(onClick)
  }

  @Builder FindRoom() {
    Column() {
      Row() {
        Text('智能找房助手')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#202733')
        Blank()
        Text('基础模拟')
          .fontSize(11)
          .fontColor('#6D7B8F')
          .padding({ left: 9, right: 9, top: 4, bottom: 4 })
          .backgroundColor('#EEF4FB')
          .borderRadius(12)
      }
      .width('100%')
      .margin({ bottom: 12 })

      Row() {
        this.FindRoomCard(
          $r('app.media.ic_commute'),
          '通勤找房',
          '按目的地、预算和收藏偏好立即筛选',
          '立即筛选',
          () => { this.goCommuteSearch() }
        )
        this.FindRoomCard(
          $r('app.media.ic_map_search'),
          '地图找房',
          '查看周边配套、地铁沿线、热门社区',
          '查看地图',
          () => { this.goMapSearch('map') }
        )
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      Row() {
        this.ScenePill('周边配套', () => { this.goMapSearch('amenities') })
        this.ScenePill('地铁沿线', () => { this.goMapSearch('subway') })
        this.ScenePill('热门社区', () => { this.goMapSearch('community') })
      }
      .width('100%')
      .margin({ top: 12 })
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(20)
    .shadow({ radius: 20, color: '#18000000', offsetX: 0, offsetY: 9 })
    .margin({ left: 20, right: 20, bottom: 16 })
  }

  @Builder FindRoomCard(icon: Resource, title: string, desc: string, action: string, onClick: () => void) {
    Column() {
      Row() {
        Image(icon)
          .width(26)
          .height(26)
          .fillColor(this.primaryColor)
      }
      .width(44)
      .height(44)
      .borderRadius(16)
      .backgroundColor('#F1F6FD')
      .justifyContent(FlexAlign.Center)

      Text(title)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor('#202733')
        .margin({ top: 12 })
      Text(desc)
        .fontSize(12)
        .fontColor('#6D7B8F')
        .lineHeight(18)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ top: 5 })

      Blank()

      Text(action)
        .fontSize(12)
        .fontWeight(FontWeight.Medium)
        .fontColor(this.primaryColor)
        .padding({ left: 12, right: 12, top: 7, bottom: 7 })
        .backgroundColor('#EEF5FF')
        .borderRadius(14)
        .margin({ top: 10 })
    }
    .width('48%')
    .height(174)
    .alignItems(HorizontalAlign.Start)
    .padding(14)
    .backgroundColor('#FAFCFF')
    .border({ width: 1, color: '#EEF3F8' })
    .borderRadius(18)
    .onClick(onClick)
  }

  @Builder ScenePill(label: string, onClick: () => void) {
    Text(label)
      .fontSize(12)
      .fontColor('#5B6678')
      .padding({ left: 11, right: 11, top: 7, bottom: 7 })
      .backgroundColor('#F4F7FB')
      .borderRadius(14)
      .margin({ right: 8 })
      .onClick(onClick)
  }

  @Builder FavoriteSummary() {
    Column() {
      Row() {
        Text('收藏洞察')
          .fontSize(17)
          .fontWeight(FontWeight.Bold)
          .fontColor('#202733')
        Blank()
        Text('本地模拟')
          .fontSize(11)
          .fontColor('#8A94A6')
      }
      .width('100%')
      .margin({ bottom: 12 })

      Row() {
        this.SummaryCell(`${this.favoriteItems.length}`, '收藏数量')
        this.SummaryCell(this.favoriteItems.length > 0 ? `${this.getAverageFavoriteRent()}` : '--', '平均租金')
      }
      .width('100%')

      Row() {
        Text('最近收藏')
          .fontSize(12)
          .fontColor('#8A94A6')
        Text(this.getLatestFavoriteTitle())
          .fontSize(13)
          .fontColor('#202733')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .layoutWeight(1)
          .textAlign(TextAlign.End)
      }
      .width('100%')
      .margin({ top: 14 })
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(20)
    .shadow({ radius: 18, color: '#12000000', offsetX: 0, offsetY: 8 })
    .margin({ left: 20, right: 20, bottom: 12 })
  }

  @Builder SummaryCell(value: string, label: string) {
    Column() {
      Text(value)
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .fontColor(this.primaryColor)
      Text(label)
        .fontSize(11)
        .fontColor('#8A94A6')
        .margin({ top: 3 })
    }
    .layoutWeight(1)
    .height(72)
    .justifyContent(FlexAlign.Center)
    .backgroundColor('#F6F9FD')
    .borderRadius(16)
    .margin({ right: 8 })
  }

  @Builder FavoriteEmptyState() {
    Column() {
      Image($r('app.media.ic_empty'))
        .width(92)
        .height(92)
        .margin({ top: 42, bottom: 12 })
      Text('还没有收藏喔，先去逛逛吧！')
        .fontSize(15)
        .fontColor('#6D7B8F')
      Text('收藏后会同步用于通勤找房和地图找房')
        .fontSize(12)
        .fontColor('#A8B0BD')
        .margin({ top: 6 })
      Text('去首页看看')
        .fontSize(13)
        .fontColor('#FFFFFF')
        .padding({ left: 18, right: 18, top: 9, bottom: 9 })
        .backgroundColor(this.primaryColor)
        .borderRadius(16)
        .margin({ top: 16 })
        .onClick(() => { this.currentTab = 0 })
    }
    .width('100%')
    .padding({ bottom: 30 })
  }

  @Builder DestinationDialog() {
    Column() {
      Blank()
      Column() {
        Text('设置通勤目的地')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#202733')
          .width('100%')

        Row() {
          Image($r('app.media.ic_location'))
            .width(18)
            .height(18)
            .fillColor(this.primaryColor)
            .margin({ left: 12, right: 8 })
          TextInput({ placeholder: '请输入公司、学校或商圈', text: this.commuteDraft })
            .layoutWeight(1)
            .height(44)
            .backgroundColor(Color.Transparent)
            .fontSize(14)
            .onChange((value: string) => { this.commuteDraft = value })
        }
        .width('100%')
        .height(48)
        .backgroundColor('#F6F9FD')
        .borderRadius(16)
        .margin({ top: 16, bottom: 16 })

        Row() {
          Text('取消')
            .fontSize(14)
            .fontColor('#6D7B8F')
            .layoutWeight(1)
            .height(44)
            .textAlign(TextAlign.Center)
            .backgroundColor('#F4F7FB')
            .borderRadius(16)
            .onClick(() => { this.destinationDialogVisible = false })
          Text('保存')
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .fontColor('#FFFFFF')
            .layoutWeight(1)
            .height(44)
            .textAlign(TextAlign.Center)
            .backgroundColor(this.primaryColor)
            .borderRadius(16)
            .margin({ left: 10 })
            .onClick(() => { this.confirmDestination() })
        }
        .width('100%')
      }
      .width('100%')
      .padding(20)
      .backgroundColor('#FFFFFF')
      .borderRadius({ topLeft: 24, topRight: 24 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#66000000')
  }

  @Builder ServiceTabV2() {
    Stack() {
      Column() {
        Stack() {
          Image($r('app.media.sr_service_bg'))
            .width('100%')
            .height(292)
            .objectFit(ImageFit.Cover)
            .opacity(0.92)
          Column()
            .width('100%')
            .height(292)
            .linearGradient({
              direction: GradientDirection.Bottom,
              colors: [['#BFE1FF22', 0.0], ['#F6F8FB66', 0.58], ['#F6F8FB', 1.0]]
            })
        }
        .width('100%')
        .height(292)
        Blank()
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F6F8FB')

      Scroll() {
        Column() {
          this.ServiceNavBar()
          this.VipCard()
          this.HomeServiceGrid()
        }
        .width('100%')
        .padding({ bottom: 28 })
      }
      .width('100%')
      .height('100%')
      .scrollBar(BarState.Off)

      if (this.serviceAddressDialogVisible) {
        this.ServiceAddressDialog()
      }
    }
    .width('100%')
    .height('100%')
  }

  @Builder ServiceNavBar() {
    Row() {
      Column() {
        Text('当前居住地址')
          .fontSize(11)
          .fontColor('#5F6D7E')
        Row() {
          Image($r('app.media.ic_location'))
            .width(16)
            .height(16)
            .fillColor(this.primaryColor)
            .margin({ right: 5 })
          Text(this.serviceAddress)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#202733')
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
          Image($r('app.media.ic_arrow_right'))
            .width(14)
            .height(14)
            .fillColor('#6D7B8F')
            .margin({ left: 2 })
        }
        .margin({ top: 4 })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
      .onClick(() => { this.openServiceAddressDialog() })

      Row() {
        Image($r('app.media.ic_customer_service'))
          .width(21)
          .height(21)
          .fillColor(this.primaryColor)
      }
      .width(42)
      .height(42)
      .borderRadius(16)
      .backgroundColor('#FFFFFF')
      .justifyContent(FlexAlign.Center)
      .shadow({ radius: 12, color: '#14000000', offsetX: 0, offsetY: 6 })
      .onClick(() => { promptAction.showToast({ message: '客服功能暂未接入' }) })
    }
    .width('100%')
    .height(82)
    .padding({ left: 20, right: 20, top: 14, bottom: 10 })
  }

  @Builder VipCard() {
    Column() {
      Row() {
        Column() {
          Text('VIP 会员')
            .fontSize(13)
            .fontColor('#6D7B8F')
          Text('尊享生活服务')
            .fontSize(22)
            .fontWeight(FontWeight.Bold)
            .fontColor('#202733')
            .margin({ top: 4 })
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)
        Text('黄金会员')
          .fontSize(12)
          .fontWeight(FontWeight.Medium)
          .fontColor(this.primaryColor)
          .padding({ left: 12, right: 12, top: 7, bottom: 7 })
          .backgroundColor('#EEF5FF')
          .borderRadius(14)
      }
      .width('100%')

      Row() {
        Text('有效期')
          .fontSize(12)
          .fontColor('#8A94A6')
        Text('2026.12.31')
          .fontSize(13)
          .fontWeight(FontWeight.Medium)
          .fontColor('#202733')
          .margin({ left: 8 })
        Blank()
        Image($r('app.media.ic_arrow_right'))
          .width(16)
          .height(16)
          .fillColor('#8A94A6')
      }
      .width('100%')
      .margin({ top: 18 })
    }
    .width('100%')
    .padding(18)
    .backgroundColor('#FFFFFF')
    .borderRadius(20)
    .shadow({ radius: 24, color: '#1A000000', offsetX: 0, offsetY: 10 })
    .margin({ left: 20, right: 20, top: 116, bottom: 18 })
    .onClick(() => { this.goVipDetail() })
  }

  @Builder HomeServiceGrid() {
    Column() {
      Row() {
        Text('家庭服务')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#202733')
        Blank()
        Text('15 项')
          .fontSize(12)
          .fontColor('#8A94A6')
      }
      .width('100%')
      .margin({ bottom: 14 })

      Grid() {
        GridItem() { this.ServiceGridItem($r('app.media.ic_service_clean'), '日常保洁', '全屋清洁', '热门') }
        GridItem() { this.ServiceGridItem($r('app.media.ic_service_repair'), '维修上门', '水电五金', '') }
        GridItem() { this.ServiceGridItem($r('app.media.ic_service_appliance'), '家电清洗', '空调冰箱', '') }
        GridItem() { this.ServiceGridItem($r('app.media.ic_service_laundry'), '洗衣护理', '取送到家', '') }
        GridItem() { this.ServiceGridItem($r('app.media.ic_service_move'), '搬家服务', '打包搬运', '') }
        GridItem() { this.ServiceGridItem($r('app.media.ic_service_lock'), '开锁换锁', '安全上门', '') }
        GridItem() { this.ServiceGridItem($r('app.media.ic_service_pipe'), '管道疏通', '厨房卫浴', '') }
        GridItem() { this.ServiceGridItem($r('app.media.ic_service_air'), '空气治理', '除醛净味', '精选') }
        GridItem() { this.ServiceGridItem($r('app.media.ic_service_wifi'), '宽带网络', '安装维护', '') }
        GridItem() { this.ServiceGridItem($r('app.media.ic_service_pet'), '宠物照看', '临时托管', '') }
        GridItem() { this.ServiceGridItem($r('app.media.ic_service_plant'), '绿植养护', '修剪浇灌', '') }
        GridItem() { this.ServiceGridItem($r('app.media.ic_service_curtain'), '窗帘清洗', '拆装清洁', '') }
        GridItem() { this.ServiceGridItem($r('app.media.ic_service_bed'), '床品换洗', '深度除螨', '') }
        GridItem() { this.ServiceGridItem($r('app.media.ic_service_disinfect'), '消毒除菌', '安心入住', '') }
        GridItem() { this.ServiceGridItem($r('app.media.ic_service_housekeeper'), '专属管家', '会员优先', 'VIP') }
      }
      .columnsTemplate('1fr 1fr 1fr')
      .rowsTemplate('1fr 1fr 1fr 1fr 1fr')
      .columnsGap(10)
      .rowsGap(10)
      .width('100%')
      .height(560)
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(20)
    .shadow({ radius: 20, color: '#12000000', offsetX: 0, offsetY: 8 })
    .margin({ left: 20, right: 20, bottom: 20 })
  }

  @Builder ServiceGridItem(icon: Resource, title: string, subtitle: string, badge: string) {
    Stack({ alignContent: Alignment.TopEnd }) {
      Column() {
        Row() {
          Image(icon)
            .width(25)
            .height(25)
            .fillColor(this.primaryColor)
        }
        .width(44)
        .height(44)
        .justifyContent(FlexAlign.Center)
        .backgroundColor('#F2F7FD')
        .borderRadius(16)

        Text(title)
          .fontSize(13)
          .fontWeight(FontWeight.Medium)
          .fontColor('#202733')
          .maxLines(1)
          .margin({ top: 8 })
        Text(subtitle)
          .fontSize(10)
          .fontColor('#8A94A6')
          .maxLines(1)
          .margin({ top: 3 })
      }
      .width('100%')
      .height(104)
      .justifyContent(FlexAlign.Center)
      .backgroundColor('#FAFCFF')
      .border({ width: 1, color: '#EEF3F8' })
      .borderRadius(16)

      if (badge.length > 0) {
        Text(badge)
          .fontSize(9)
          .fontColor(this.primaryColor)
          .padding({ left: 6, right: 6, top: 2, bottom: 2 })
          .backgroundColor('#EAF3FF')
          .borderRadius(8)
          .margin({ top: 7, right: 7 })
      }
    }
    .width('100%')
    .height(104)
    .onClick(() => { this.showServiceToast(title) })
  }

  @Builder ServiceAddressDialog() {
    Column() {
      Blank()
      Column() {
        Text('选择服务地址')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#202733')
          .width('100%')
          .margin({ bottom: 14 })

        this.ServiceAddressOption('阳光花园 12 号楼')
        this.ServiceAddressOption('翠苑新村 5 幢')
        this.ServiceAddressOption('城市花园 3 单元')

        Row() {
          Text('取消')
            .fontSize(14)
            .fontColor('#6D7B8F')
            .layoutWeight(1)
            .height(44)
            .textAlign(TextAlign.Center)
            .backgroundColor('#F4F7FB')
            .borderRadius(16)
            .onClick(() => { this.serviceAddressDialogVisible = false })
          Text('保存')
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .fontColor('#FFFFFF')
            .layoutWeight(1)
            .height(44)
            .textAlign(TextAlign.Center)
            .backgroundColor(this.primaryColor)
            .borderRadius(16)
            .margin({ left: 10 })
            .onClick(() => { this.confirmServiceAddress() })
        }
        .width('100%')
        .margin({ top: 14 })
      }
      .width('100%')
      .padding(20)
      .backgroundColor('#FFFFFF')
      .borderRadius({ topLeft: 24, topRight: 24 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#66000000')
  }

  @Builder ServiceAddressOption(address: string) {
    Row() {
      Image($r('app.media.ic_location'))
        .width(18)
        .height(18)
        .fillColor(this.serviceAddressDraft === address ? this.primaryColor : '#8A94A6')
        .margin({ right: 10 })
      Text(address)
        .fontSize(14)
        .fontColor('#202733')
        .layoutWeight(1)
      if (this.serviceAddressDraft === address) {
        Circle()
          .width(8)
          .height(8)
          .fill(this.primaryColor)
      }
    }
    .width('100%')
    .height(48)
    .padding({ left: 14, right: 14 })
    .backgroundColor(this.serviceAddressDraft === address ? '#EEF5FF' : '#F6F9FD')
    .borderRadius(16)
    .margin({ bottom: 10 })
    .onClick(() => { this.serviceAddressDraft = address })
  }

  @Builder ServiceTab() {
    Column() {
      this.SimpleHeader('服务')
      Scroll() {
        Column() {
          TileList({
            items: this.tileItems,
            columns: 3,
            showSubtitle: true,
            onItemClick: (item: TileItem) => { this.onTileClick(item) }
          })
          .margin({ top: 16, bottom: 16 })

          PlanList({
            steps: this.planSteps,
            title: '看房流程',
            onStepClick: (step: PlanStep, index: number) => {
              promptAction.showToast({ message: `第${index + 1}步：${step.title}` });
            }
          })
        }
        .width('100%')
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F6F8FB')
  }

  @Builder DiscoverTabV2() {
    Stack() {
      Column() {
        Image($r('app.media.sr_discover_bg'))
          .width('100%')
          .height(310)
          .objectFit(ImageFit.Cover)
          .opacity(0.9)
        Blank()
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F6F8FB')

      Column()
        .width('100%')
        .height('100%')
        .linearGradient({
          direction: GradientDirection.Bottom,
          colors: [['#DCEEFF22', 0.0], ['#F6F8FB99', 0.36], ['#F6F8FB', 0.72]]
        })

      Refresh({ refreshing: $$this.discoverRefreshing }) {
        Scroll() {
          Column() {
            Row() {
              Column() {
                Text('发现')
                  .fontSize(24)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#202733')
                Text('城市生活与租住灵感')
                  .fontSize(12)
                  .fontColor('#5F6D7E')
                  .margin({ top: 4 })
              }
              .alignItems(HorizontalAlign.Start)
              .layoutWeight(1)
            }
            .width('100%')
            .padding({ left: 20, right: 20, top: 16, bottom: 12 })

            this.DiscoverBannerSwiper()
            this.DiscoverAdCard()
            this.DiscoverTagFlow()

            Row() {
              Text('精选文章')
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .fontColor('#202733')
              Blank()
              Text('双列推荐')
                .fontSize(12)
                .fontColor('#8A94A6')
            }
            .width('100%')
            .padding({ left: 20, right: 20, top: 4, bottom: 12 })

            Grid() {
              GridItem() { this.ArticleCard($r('app.media.sr_article_01'), '看房前先确认这 6 件事', '从采光、噪音到物业响应，减少无效看房。', '看房清单', '住研编辑部', '6 分钟', 1240, 0) }
              GridItem() { this.ArticleCard($r('app.media.sr_article_02'), '通勤 45 分钟内怎么选小区', '用目的地倒推地铁、公交和步行半径。', '通勤', '城市观察', '5 分钟', 980, 1) }
              GridItem() { this.ArticleCard($r('app.media.sr_article_03'), '小户型收纳的高级感做法', '不堆满柜子，也能让日常更有秩序。', '收纳', '生活方式', '4 分钟', 760, 2) }
              GridItem() { this.ArticleCard($r('app.media.sr_article_04'), '社区配套要看哪些细节', '菜场、快递、夜间照明和安静程度都很关键。', '社区', '租住指南', '7 分钟', 1420, 3) }
              GridItem() { this.ArticleCard($r('app.media.sr_article_05'), '租金预算别只看月租', '押金、通勤、家具补齐都要算进总成本。', '预算', '财务规划', '5 分钟', 1180, 4) }
              GridItem() { this.ArticleCard($r('app.media.sr_article_06'), '入住第一周的服务清单', '保洁、宽带、门锁和家电检查一次安排好。', '入住', '服务管家', '6 分钟', 890, 5) }
            }
            .columnsTemplate('1fr 1fr')
            .columnsGap(12)
            .rowsGap(12)
            .padding({ left: 20, right: 20, bottom: 28 })
          }
          .width('100%')
        }
        .width('100%')
        .height('100%')
        .scrollBar(BarState.Off)
      }
      .onRefreshing(() => { this.refreshDiscover() })
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
  }

  @Builder DiscoverBannerSwiper() {
    Swiper() {
      this.DiscoverBanner($r('app.media.sr_discover_banner_01'), '住进通勤刚刚好的城市半径', '城市生活', '选择离目的地更近的生活节奏')
      this.DiscoverBanner($r('app.media.sr_discover_banner_02'), '社区里的安全感从哪里来', '社区观察', '从快递、绿化到夜间照明')
      this.DiscoverBanner($r('app.media.sr_discover_banner_03'), '周末也值得认真生活', '生活方式', '发现住处周边的小店和街区')
    }
    .width('100%')
    .height(178)
    .indicator(true)
    .autoPlay(true)
    .interval(3500)
    .loop(true)
    .margin({ bottom: 16 })
  }

  @Builder DiscoverBanner(image: Resource, title: string, tag: string, summary: string) {
    Stack({ alignContent: Alignment.BottomStart }) {
      Image(image)
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)
        .borderRadius(22)
      Column()
        .width('100%')
        .height('100%')
        .borderRadius(22)
        .linearGradient({
          direction: GradientDirection.Bottom,
          colors: [['#00000000', 0.25], ['#00000088', 1.0]]
        })
      Column() {
        Text(tag)
          .fontSize(11)
          .fontColor('#FFFFFF')
          .padding({ left: 9, right: 9, top: 4, bottom: 4 })
          .backgroundColor('#552E6FDC')
          .borderRadius(12)
        Text(title)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FFFFFF')
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ top: 8 })
        Text(summary)
          .fontSize(12)
          .fontColor('#E9EEF7')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ top: 4 })
      }
      .alignItems(HorizontalAlign.Start)
      .padding(18)
    }
    .width('100%')
    .height(178)
    .padding({ left: 20, right: 20 })
    .onClick(() => { this.goArticleDetail(title, summary, image, tag) })
  }

  @Builder DiscoverAdCard() {
    Row() {
      Column() {
        Text('会员服务')
          .fontSize(12)
          .fontColor(this.primaryColor)
          .fontWeight(FontWeight.Medium)
        Text('开通 VIP，获得更快的家庭服务响应')
          .fontSize(17)
          .fontWeight(FontWeight.Bold)
          .fontColor('#202733')
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ top: 5 })
        Text('服务地址专属权益 · 平台认证人员')
          .fontSize(12)
          .fontColor('#6D7B8F')
          .margin({ top: 6 })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
      Image($r('app.media.ic_service_housekeeper'))
        .width(38)
        .height(38)
        .fillColor(this.primaryColor)
        .margin({ left: 12 })
    }
    .width('100%')
    .padding(18)
    .backgroundColor('#FFFFFF')
    .borderRadius(20)
    .shadow({ radius: 20, color: '#16000000', offsetX: 0, offsetY: 9 })
    .margin({ left: 20, right: 20, bottom: 18 })
    .onClick(() => { this.goDiscoverAdPage() })
  }

  @Builder DiscoverTagFlow() {
    Column() {
      Row() {
        Text('热门标签')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#202733')
        Blank()
      }
      .width('100%')
      .margin({ bottom: 10 })

      Flex({ wrap: FlexWrap.Wrap }) {
        this.TagChip('近地铁')
        this.TagChip('整租')
        this.TagChip('精装修')
        this.TagChip('通勤友好')
        this.TagChip('预算规划')
        this.TagChip('社区配套')
        this.TagChip('看房清单')
        this.TagChip('拎包入住')
      }
      .width('100%')
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(20)
    .shadow({ radius: 16, color: '#10000000', offsetX: 0, offsetY: 7 })
    .margin({ left: 20, right: 20, bottom: 18 })
  }

  @Builder TagChip(label: string) {
    Text(label)
      .fontSize(12)
      .fontColor('#5B6678')
      .padding({ left: 12, right: 12, top: 7, bottom: 7 })
      .backgroundColor('#F3F7FC')
      .borderRadius(14)
      .margin({ right: 8, bottom: 8 })
  }

  @Builder ArticleCard(image: Resource, title: string, summary: string, tag: string, author: string, time: string, reads: number, index: number) {
    Column() {
      Image(image)
        .width('100%')
        .height(index % 3 === 1 ? 142 : 118)
        .objectFit(ImageFit.Cover)
        .borderRadius({ topLeft: 18, topRight: 18 })
      Column() {
        Text(tag)
          .fontSize(10)
          .fontColor(this.primaryColor)
          .padding({ left: 8, right: 8, top: 3, bottom: 3 })
          .backgroundColor('#EEF5FF')
          .borderRadius(10)
        Text(title)
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .fontColor('#202733')
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .lineHeight(20)
          .margin({ top: 8 })
        Text(summary)
          .fontSize(12)
          .fontColor('#6D7B8F')
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .lineHeight(17)
          .margin({ top: 6 })
        Row() {
          Text(author)
            .fontSize(10)
            .fontColor('#A8B0BD')
            .maxLines(1)
            .layoutWeight(1)
          Text(`${reads} 阅读`)
            .fontSize(10)
            .fontColor('#A8B0BD')
        }
        .width('100%')
        .margin({ top: 10 })
        Text(time)
          .fontSize(10)
          .fontColor('#A8B0BD')
          .margin({ top: 4 })
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
      .padding(12)
    }
    .width('100%')
    .backgroundColor('#FFFFFF')
    .borderRadius(18)
    .shadow({ radius: 14, color: '#12000000', offsetX: 0, offsetY: 7 })
    .onClick(() => { promptAction.showToast({ message: title }) })
  }

  @Builder DiscoverTab() {
    Column() {
      this.SimpleHeader('发现')
      Scroll() {
        Column() {
          ForEach(this.discoverData.articles, (item: DiscoverArticle) => {
            Column() {
              Image(item.cover)
                .width('100%')
                .height(160)
                .borderRadius({ topLeft: 18, topRight: 18 })
                .objectFit(ImageFit.Cover)
              Column() {
                Text(item.title)
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#202733')
                  .maxLines(2)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .width('100%')
                Text(item.summary)
                  .fontSize(13)
                  .fontColor('#8A94A6')
                  .maxLines(2)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .width('100%')
                  .margin({ top: 6 })
              }
              .padding(14)
            }
            .width('100%')
            .backgroundColor('#FFFFFF')
            .borderRadius(18)
            .margin({ left: 20, right: 20, bottom: 12 })
            .shadow({ radius: 12, color: '#12000000', offsetX: 0, offsetY: 6 })
          })
        }
        .width('100%')
        .padding({ top: 12 })
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F6F8FB')
  }

  @Builder ProfileTab() {
    Column() {
      Row() {
        Image($r('app.media.ic_avatar_default'))
          .width(64)
          .height(64)
          .borderRadius(32)
          .fillColor(this.primaryColor)
        Column() {
          Text('未登录')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#202733')
          Text('登录后享受更多服务')
            .fontSize(13)
            .fontColor('#8A94A6')
            .margin({ top: 4 })
        }
        .alignItems(HorizontalAlign.Start)
        .margin({ left: 12 })
        Blank()
        Image($r('app.media.ic_arrow_right'))
          .width(18)
          .height(18)
          .fillColor('#A8B0BD')
      }
      .width('100%')
      .padding(24)
      .backgroundColor('#FFFFFF')
      .borderRadius({ bottomLeft: 24, bottomRight: 24 })
      .onClick(() => { router.pushUrl({ url: 'pages/Index' }) })

      Column() {
        this.ProfileMenuItem($r('app.media.ic_my_order'), '我的预约', () => {
          router.pushUrl({ url: 'pages/OrderListPage' })
        })
        this.ProfileMenuItem($r('app.media.ic_my_favorite'), '我的收藏', () => {})
        this.ProfileMenuItem($r('app.media.ic_my_coupon'), '优惠券', () => {})
        this.ProfileMenuItem($r('app.media.ic_tab_discover'), '组件展示', () => {
          router.pushUrl({ url: 'pages/DemoPage' })
        })
        this.ProfileMenuItem($r('app.media.ic_my_contact'), '联系客服', () => {})
      }
      .width('100%')
      .backgroundColor('#FFFFFF')
      .borderRadius(18)
      .padding({ left: 16, right: 16 })
      .margin(20)
      .shadow({ radius: 14, color: '#16000000', offsetX: 0, offsetY: 7 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F6F8FB')
  }

  @Builder SimpleHeader(title: string) {
    Row() {
      Text(title)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor('#202733')
    }
    .width('100%')
    .height(56)
    .padding({ left: 20, right: 20 })
    .backgroundColor('#FFFFFF')
  }

  @Builder EmptyState(title: string, subtitle: string) {
    Column() {
      Image($r('app.media.ic_empty'))
        .width(120)
        .height(120)
        .margin({ top: 120, bottom: 16 })
      Text(title)
        .fontSize(16)
        .fontColor('#8A94A6')
      Text(subtitle)
        .fontSize(14)
        .fontColor('#C0C7D2')
        .margin({ top: 8 })
    }
    .layoutWeight(1)
    .justifyContent(FlexAlign.Center)
  }

  @Builder ProfileMenuItem(icon: Resource, label: string, onClick: () => void) {
    Row() {
      Image(icon)
        .width(22)
        .height(22)
        .fillColor(this.primaryColor)
      Text(label)
        .fontSize(15)
        .fontColor('#202733')
        .margin({ left: 12 })
      Blank()
      Image($r('app.media.ic_arrow_right'))
        .width(16)
        .height(16)
        .fillColor('#A8B0BD')
    }
    .width('100%')
    .height(54)
    .onClick(onClick)
  }

  @Builder TabContentBuilder(index: number) {
    if (index === 0) { this.HomeTab() }
    else if (index === 1) { this.FavoriteTabV2() }
    else if (index === 2) { this.ServiceTabV2() }
    else if (index === 3) { this.DiscoverTabV2() }
    else { this.ProfileTab() }
  }

  build() {
    Column() {
      Tabs({ index: this.currentTab }) {
        ForEach(this.tabs, (tab: string, index: number) => {
          TabContent() {
            this.TabContentBuilder(index)
          }
          .tabBar(this.TabBarBuilder(tab, index))
        })
      }
      .barPosition(BarPosition.End)
      .onChange((index: number) => { this.currentTab = index })
      .scrollable(false)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F6F8FB')
  }

  @Builder TabBarBuilder(title: string, index: number) {
    Column() {
      Image(this.getTabIcon(index))
        .width(24)
        .height(24)
        .fillColor(this.currentTab === index ? this.primaryColor : '#A8B0BD')
      Text(title)
        .fontSize(10)
        .margin({ top: 2 })
        .fontColor(this.currentTab === index ? this.primaryColor : '#8A94A6')
    }
    .width('100%')
    .height(58)
    .justifyContent(FlexAlign.Center)
  }

  getTabIcon(index: number): Resource {
    const icons: Resource[] = [
      $r('app.media.ic_tab_home'),
      $r('app.media.ic_tab_fav'),
      $r('app.media.ic_tab_service'),
      $r('app.media.ic_tab_discover'),
      $r('app.media.ic_tab_mine')
    ];
    return icons[index];
  }
}
