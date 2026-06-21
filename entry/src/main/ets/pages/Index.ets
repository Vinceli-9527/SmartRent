import { UserApi } from '../api/UserApi';
import { LoginParams } from '../model/UserData';
import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @State phone: string = ''
  @State code: string = ''
  @State codeSent: boolean = false
  @State countdown: number = 0
  @State loading: boolean = false
  @State loginMode: number = 0
  @State username: string = ''
  @State password: string = ''
  private timer: number = -1
  private primaryColor: string = '#2E6FDC'

  aboutToDisappear() {
    if (this.timer !== -1) {
      clearInterval(this.timer);
    }
  }

  sendCode() {
    if (this.phone.length !== 11) {
      promptAction.showToast({ message: '请输入正确的手机号' });
      return;
    }
    UserApi.sendCode(this.phone).then((res: import('../utils/http/Index').HttpResult<null>) => {
      if (res.code === 0) {
        this.codeSent = true;
        this.countdown = 60;
        this.timer = setInterval(() => {
          this.countdown--;
          if (this.countdown <= 0) {
            clearInterval(this.timer);
            this.timer = -1;
            this.codeSent = false;
          }
        }, 1000);
        promptAction.showToast({ message: '验证码已发送' });
      }
    });
  }

  phoneLogin() {
    if (!this.phone || !this.code) {
      promptAction.showToast({ message: '请输入手机号和验证码' });
      return;
    }
    this.loading = true;
    const params = new LoginParams();
    params.phone = this.phone;
    params.code = this.code;
    UserApi.login(params).then((res: import('../utils/http/Index').HttpResult<import('../model/UserData').LoginResult>) => {
      this.loading = false;
      if (res.code === 0) {
        router.replaceUrl({ url: 'pages/MainPage' });
      } else {
        promptAction.showToast({ message: res.message || '登录失败' });
      }
    });
  }

  adminLogin() {
    if (!this.username || !this.password) {
      promptAction.showToast({ message: '请输入管理员账号和密码' });
      return;
    }
    this.loading = true;
    setTimeout(() => {
      this.loading = false;
      if (this.username === 'admin' && this.password === '123456') {
        promptAction.showToast({ message: '管理员登录成功' });
        router.replaceUrl({ url: 'pages/MainPage' });
      } else {
        promptAction.showToast({ message: '账号或密码错误' });
      }
    }, 800);
  }

  login() {
    if (this.loginMode === 0) {
      this.phoneLogin();
    } else {
      this.adminLogin();
    }
  }

  build() {
    Column() {
      Column() {
        Image($r('app.media.ic_app_logo'))
          .width(78)
          .height(78)
          .margin({ bottom: 14 })
        Text('智慧租房')
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.primaryColor)
        Text(this.loginMode === 0 ? '手机号验证码登录' : '管理员登录')
          .fontSize(14)
          .fontColor('#8A94A6')
          .margin({ top: 8 })
      }
      .width('100%')
      .margin({ top: 66, bottom: 42 })

      if (this.loginMode === 0) {
        this.InputRow($r('app.media.ic_phone'), '请输入手机号', this.phone, InputType.PhoneNumber, 11, 16, (value: string) => {
          this.phone = value;
        })

        Row() {
          Image($r('app.media.ic_code'))
            .width(20)
            .height(20)
            .fillColor('#8A94A6')
            .margin({ left: 14, right: 8 })
          TextInput({ placeholder: '请输入验证码', text: this.code })
            .type(InputType.Number)
            .maxLength(6)
            .layoutWeight(1)
            .height(48)
            .fontSize(14)
            .backgroundColor(Color.Transparent)
            .onChange((value: string) => { this.code = value })
          Button(this.countdown > 0 ? `${this.countdown}s` : (this.codeSent ? '重新发送' : '获取验证码'))
            .fontSize(12)
            .height(32)
            .fontColor(this.countdown > 0 ? '#9AA4B2' : this.primaryColor)
            .backgroundColor(Color.Transparent)
            .enabled(this.countdown === 0)
            .margin({ right: 10 })
            .onClick(() => { this.sendCode() })
        }
        .width('100%')
        .height(50)
        .backgroundColor('#F7F9FC')
        .border({ width: 1, color: '#EEF2F7' })
        .borderRadius(18)
        .margin({ left: 32, right: 32, bottom: 32 })
      } else {
        this.InputRow($r('app.media.ic_admin_user'), '请输入管理员账号', this.username, InputType.Normal, 30, 16, (value: string) => {
          this.username = value;
        })

        this.InputRow($r('app.media.ic_admin_pwd'), '请输入密码', this.password, InputType.Password, 30, 32, (value: string) => {
          this.password = value;
        })
      }

      Button() {
        if (this.loading) {
          LoadingProgress()
            .width(20)
            .height(20)
            .color('#FFFFFF')
        } else {
          Text('登录')
            .fontSize(16)
            .fontColor('#FFFFFF')
        }
      }
      .width('100%')
      .height(48)
      .backgroundColor(this.primaryColor)
      .borderRadius(24)
      .margin({ left: 32, right: 32 })
      .enabled(!this.loading)
      .onClick(() => { this.login() })

      Text(this.loginMode === 0 ? '管理员入口' : '手机号验证码登录')
        .fontSize(14)
        .fontColor(this.primaryColor)
        .margin({ top: 20 })
        .onClick(() => {
          this.loginMode = this.loginMode === 0 ? 1 : 0;
          this.loading = false;
        })

      Row() {
        Text('登录即表示同意')
          .fontSize(12)
          .fontColor('#9AA4B2')
        Text('《用户协议》')
          .fontSize(12)
          .fontColor(this.primaryColor)
        Text('和')
          .fontSize(12)
          .fontColor('#9AA4B2')
        Text('《隐私政策》')
          .fontSize(12)
          .fontColor(this.primaryColor)
      }
      .margin({ top: 24 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }

  @Builder InputRow(icon: Resource, placeholder: string, text: string, inputType: InputType, maxLength: number, bottom: number, onChange: (value: string) => void) {
    Row() {
      Image(icon)
        .width(20)
        .height(20)
        .fillColor('#8A94A6')
        .margin({ left: 14, right: 8 })
      TextInput({ placeholder: placeholder, text: text })
        .type(inputType)
        .maxLength(maxLength)
        .layoutWeight(1)
        .height(48)
        .fontSize(14)
        .backgroundColor(Color.Transparent)
        .onChange(onChange)
    }
    .width('100%')
    .height(50)
    .backgroundColor('#F7F9FC')
    .border({ width: 1, color: '#EEF2F7' })
    .borderRadius(18)
    .margin({ left: 32, right: 32, bottom: bottom })
  }
}
