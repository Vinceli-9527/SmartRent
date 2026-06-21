import { HouseApi } from '../api/HouseApi';
import { RoomRecommendData } from '../model/RoomRecommendData';
import { router } from '@kit.ArkUI';
import { NavBar } from '../components/NavBar';
import { RoomRecommend } from '../components/RoomRecommend';

@Entry
@Component
struct RentListPage {
  @State filteredList: RoomRecommendData[] = []
  @State loading: boolean = true
  @State searchKeyword: string = ''
  @State selectedTags: string[] = []
  @State commuteMode: boolean = false
  @State commuteDestination: string = ''
  @State commuteFavoriteCount: number = 0
  @State commuteAverageRent: number = 0
  private allData: RoomRecommendData[] = []
  private tags: string[] = ['整租', '合租', '1室', '2室', '3室+', '1000以下', '1000-3000', '3000+', '近地铁', '精装修']
  private primaryColor: string = '#2E6FDC'

  aboutToAppear() {
    const routerParams = router.getParams() as Record<string, Object>;
    if (routerParams && routerParams['tag']) {
      this.selectedTags.push(routerParams['tag'] as string);
    }
    if (routerParams && (routerParams['mode'] as string) === 'commute') {
      this.commuteMode = true;
      if (routerParams['destination']) this.commuteDestination = routerParams['destination'] as string;
      if (routerParams['favoriteCount'] !== undefined) this.commuteFavoriteCount = routerParams['favoriteCount'] as number;
      if (routerParams['averageRent'] !== undefined) this.commuteAverageRent = routerParams['averageRent'] as number;
    }
    this.loadData();
  }

  loadData() {
    this.loading = true;
    HouseApi.getHouseList({ 'page': 1, 'pageSize': 50, 'keyword': '' } as Record<string, string | number>).then((res) => {
      if (res.code === 0 && res.data && res.data.length > 0) {
        this.allData = res.data;
      } else {
        this.fallbackData();
      }
      this.applyFilter();
    }).catch(() => {
      this.fallbackData();
      this.applyFilter();
    });
  }

  fallbackData() {
    const list: RoomRecommendData[] = [];
    const d1 = new RoomRecommendData();
    d1.id = 'mock1'; d1.title = '阳光花园精装两居室'; d1.price = 3200; d1.area = 85;
    d1.roomType = '2室1厅'; d1.floor = '中楼层/18层'; d1.address = '朝阳区阳光花园2号楼';
    d1.isNew = true; d1.tags = ['近地铁', '精装修', '随时看']; d1.coverUrl = $r('app.media.sr_room_01');
    list.push(d1);
    const d2 = new RoomRecommendData();
    d2.id = 'mock2'; d2.title = '翠苑新村温馨一居'; d2.price = 2200; d2.area = 45;
    d2.roomType = '1室1厅'; d2.floor = '低楼层/6层'; d2.address = '海淀区翠苑新村3栋';
    d2.tags = ['采光好', '家电齐全', '整租']; d2.coverUrl = $r('app.media.sr_room_02');
    list.push(d2);
    const d3 = new RoomRecommendData();
    d3.id = 'mock3'; d3.title = '朗诗国际大三房'; d3.price = 5500; d3.area = 120;
    d3.roomType = '3室2厅'; d3.floor = '高楼层/33层'; d3.address = '浦东新区朗诗国际8栋';
    d3.isNew = true; d3.tags = ['品质社区', '近地铁']; d3.coverUrl = $r('app.media.sr_room_03');
    list.push(d3);
    const d4 = new RoomRecommendData();
    d4.id = 'mock4'; d4.title = '城市花园小户型公寓'; d4.price = 1800; d4.area = 35;
    d4.roomType = '1室'; d4.floor = '中楼层/12层'; d4.address = '朝阳区万科城市花园';
    d4.tags = ['整租', '拎包入住']; d4.coverUrl = $r('app.media.sr_room_04');
    list.push(d4);
    const d5 = new RoomRecommendData();
    d5.id = 'mock5'; d5.title = '绿城百合公寓合租单间'; d5.price = 1200; d5.area = 20;
    d5.roomType = '3室1厅合租'; d5.floor = '高楼层/26层'; d5.address = '海淀区绿城百合公寓';
    d5.isNew = true; d5.tags = ['合租', '精装修']; d5.coverUrl = $r('app.media.sr_room_05');
    list.push(d5);
    const d6 = new RoomRecommendData();
    d6.id = 'mock6'; d6.title = '龙湖天街精装四居室'; d6.price = 6800; d6.area = 150;
    d6.roomType = '4室2厅'; d6.floor = '低楼层/8层'; d6.address = '朝阳区龙湖天街';
    d6.tags = ['精装修', '近地铁']; d6.coverUrl = $r('app.media.sr_room_06');
    list.push(d6);
    this.allData = list;
  }

  applyFilter() {
    this.loading = false;
    let result: RoomRecommendData[] = this.allData;
    if (this.searchKeyword.length > 0) {
      const kw = this.searchKeyword.toLowerCase();
      const kwFiltered: RoomRecommendData[] = [];
      result.forEach((item: RoomRecommendData) => {
        if (item.title.toLowerCase().indexOf(kw) >= 0 ||
            item.address.toLowerCase().indexOf(kw) >= 0 ||
            item.roomType.toLowerCase().indexOf(kw) >= 0) {
          kwFiltered.push(item);
        }
      });
      result = kwFiltered;
    }
    if (this.selectedTags.length > 0) {
      const tagFiltered: RoomRecommendData[] = [];
      result.forEach((item: RoomRecommendData) => {
        if (this.matchesTags(item)) tagFiltered.push(item);
      });
      result = tagFiltered;
    }
    this.filteredList = result;
  }

  matchesTags(item: RoomRecommendData): boolean {
    let passCount = 0;
    this.selectedTags.forEach((tag: string) => {
      let matched = false;
      if (tag === '整租') {
        matched = !item.tags.some((t: string) => t.indexOf('合租') >= 0);
      } else if (tag === '合租') {
        matched = item.tags.some((t: string) => t.indexOf('合租') >= 0) || item.roomType.indexOf('合租') >= 0;
      } else if (tag === '1室') {
        matched = item.roomType.startsWith('1室');
      } else if (tag === '2室') {
        matched = item.roomType.startsWith('2室');
      } else if (tag === '3室+') {
        matched = item.roomType.startsWith('3室') || item.roomType.startsWith('4室') || item.roomType.startsWith('5室');
      } else if (tag === '1000以下') {
        matched = item.price < 1000;
      } else if (tag === '1000-3000') {
        matched = item.price >= 1000 && item.price <= 3000;
      } else if (tag === '3000+') {
        matched = item.price > 3000;
      } else if (tag === '近地铁') {
        matched = item.tags.some((t: string) => t.indexOf('地铁') >= 0) || item.address.indexOf('地铁') >= 0;
      } else if (tag === '精装修') {
        matched = item.tags.some((t: string) => t.indexOf('精装') >= 0 || t.indexOf('装修') >= 0);
      }
      if (matched) passCount++;
    });
    return passCount === this.selectedTags.length;
  }

  toggleTag(tag: string) {
    const idx = this.selectedTags.indexOf(tag);
    if (idx >= 0) {
      this.selectedTags.splice(idx, 1);
    } else {
      this.selectedTags.push(tag);
    }
    this.applyFilter();
  }

  build() {
    Column() {
      NavBar({ title: '租房列表', showBack: true, onBack: () => { router.back() } })

      if (this.commuteMode) {
        Row() {
          Column() {
            Text('通勤找房')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#202733')
            Text(`目的地 ${this.commuteDestination || '未设置'} · 收藏 ${this.commuteFavoriteCount} 套 · 均租 ${this.commuteAverageRent > 0 ? this.commuteAverageRent : '--'} 元/月`)
              .fontSize(12)
              .fontColor('#6D7B8F')
              .margin({ top: 4 })
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#FFFFFF')
        .borderRadius(18)
        .shadow({ radius: 14, color: '#12000000', offsetX: 0, offsetY: 7 })
        .margin({ left: 20, right: 20, top: 12, bottom: 4 })
      }

      Column() {
        Row() {
          Image($r('app.media.ic_search'))
            .width(16)
            .height(16)
            .fillColor('#8A94A6')
            .margin({ left: 12, right: 6 })
          TextInput({ placeholder: '搜索小区、商圈', text: this.searchKeyword })
            .layoutWeight(1)
            .height(40)
            .backgroundColor(Color.Transparent)
            .fontSize(14)
            .onChange((v: string) => {
              this.searchKeyword = v;
              this.applyFilter();
            })
        }
        .width('100%')
        .height(42)
        .backgroundColor('#F7F9FC')
        .border({ width: 1, color: '#EEF2F7' })
        .borderRadius(18)
        .margin({ left: 20, right: 20, bottom: 10 })

        Scroll() {
          Row() {
            ForEach(this.tags, (tag: string) => {
              Text(tag)
                .fontSize(12)
                .padding({ left: 12, right: 12, top: 7, bottom: 7 })
                .borderRadius(14)
                .fontColor(this.selectedTags.indexOf(tag) >= 0 ? '#FFFFFF' : '#667085')
                .backgroundColor(this.selectedTags.indexOf(tag) >= 0 ? this.primaryColor : '#F2F6FC')
                .margin({ right: 8 })
                .onClick(() => { this.toggleTag(tag) })
            })
          }
          .padding({ left: 20, right: 20 })
        }
        .scrollable(ScrollDirection.Horizontal)
        .scrollBar(BarState.Off)
        .height(44)
      }
      .backgroundColor('#FFFFFF')
      .padding({ top: 8, bottom: 8 })

      if (this.selectedTags.length > 0 || this.searchKeyword.length > 0) {
        Row() {
          Text(`找到 ${this.filteredList.length} 个房源`)
            .fontSize(13)
            .fontColor('#8A94A6')
        }
        .width('100%')
        .padding({ left: 20, top: 8, bottom: 2 })
      }

      if (this.loading) {
        Column() {
          LoadingProgress().width(36).height(36)
          Text('加载中...')
            .fontSize(14)
            .fontColor('#8A94A6')
            .margin({ top: 12 })
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else if (this.filteredList.length === 0) {
        Column() {
          Image($r('app.media.ic_empty'))
            .width(120)
            .height(120)
            .margin({ top: 100, bottom: 16 })
          Text('暂无房源')
            .fontSize(16)
            .fontColor('#8A94A6')
          Text('换个筛选条件试试')
            .fontSize(14)
            .fontColor('#C0C7D2')
            .margin({ top: 8 })
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        Scroll() {
          RoomRecommend({
            list: this.filteredList,
            title: '',
            loading: false,
            hasMore: false
          })
        }
        .layoutWeight(1)
        .scrollBar(BarState.Off)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F6F8FB')
  }
}
