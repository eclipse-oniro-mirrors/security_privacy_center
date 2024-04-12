/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { WidthPercent } from '../common/util/ConfigData';
import HeadComponent from '../common/component/headComponent';
import CmFaPresenter from '../presenter/CmFaPresenter';
import { GlobalContext } from '../common/GlobalContext';
import ComponentConfig from '../common/component/ComponentConfig';
import router from '@ohos.router';
import checkUserAuthModel from '../model/CheckUserAuthModel';


@Entry
@Component
struct CertificateComponent {
  @State touchedItem: boolean = false;
  @State columnMargin: string = '12vp';
  @State mFaPresenter: CmFaPresenter = CmFaPresenter.getInstance();
  @State isTouched: boolean = false;
  @State installCertFlag: boolean = false;
  @State pageKey: string = '';

  checkUserAuth() {
    let titleStr = getContext().resourceManager.getStringSync($r('app.string.Identity_Authentication'));
    checkUserAuthModel.auth(titleStr, (authResult: boolean) => {
      if (authResult) {
        console.log('checkUserAuth success');
        if (this.installCertFlag) {
          this.mFaPresenter.startInstallCert();
        } else {
          this.mFaPresenter.startInstallEvidence();
        }
      }
    })
  }

  build() {
    Column() {
      GridRow({ columns: 12, gutter: vp2px(1) === 2 ? '12vp' : '0vp' }) {
        GridCol({ span: 12 }) {
          Row({}) {
            Column({ space: this.columnMargin }) {
              HeadComponent({ headName: $r('app.string.installInStorageDevice') })
              Column({ space: this.columnMargin }) {
                Column() {
                  Column() {
                    Row() {
                      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
                        Text($r('app.string.CA_cert'))
                          .fontSize($r('sys.float.ohos_id_text_size_body1'))
                          .fontColor($r('sys.color.ohos_id_color_text_primary'))
                          .fontWeight(FontWeight.Medium)
                          .margin({ left: $r('app.float.wh_value_12') })
                          .textAlign(TextAlign.Start)
                      }
                    }
                    .margin({ top: $r('app.float.wh_value_4') })
                    .height($r('app.float.wh_value_48'))
                    .onClick(() => {
                      AlertDialog.show({
                        title: $r('app.string.root_certificate'),
                        message: $r('app.string.root_certificate_message'),
                        autoCancel: true,
                        alignment:DialogAlignment.Center,
                        offset: { dx: 0, dy: 0},
                        gridCount: 4,
                        primaryButton: {
                          value: $r('app.string.root_certificate_cancel'),
                          action: () => {
                          }
                        },
                        secondaryButton: {
                          value: $r('app.string.root_certificate_continue'),
                          action: () => {
                            this.installCertFlag = true
                            this.checkUserAuth()
                          }
                        }
                      })
                    })

                    Divider()
                      .strokeWidth(1)
                      .color($r("app.color.sys_list_divider_color_000000"))
                      .margin({
                        left: $r('app.float.wh_value_12'),
                        right: $r('app.float.wh_value_12')
                      })

                    Row() {
                      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
                        Text($r('app.string.user_certificate_credentials'))
                          .fontSize($r('sys.float.ohos_id_text_size_body1'))
                          .fontColor($r('sys.color.ohos_id_color_text_primary'))
                          .fontWeight(FontWeight.Medium)
                          .margin({ left: $r('app.float.wh_value_12') })
                          .textAlign(TextAlign.Start)
                      }
                      .onClick(() => {
                        this.installCertFlag = false
                        this.checkUserAuth()
                      })
                    }
                    .height($r('app.float.wh_value_48'))
                  }
                  .backgroundColor($r('sys.color.ohos_id_color_card_bg'))
                  .borderRadius($r('app.float.radius_20'))
                  .height(ComponentConfig.WH_100_100)
                  .width(ComponentConfig.WH_100_100)
                  .linearGradient(this.isTouched ? {
                    angle: 90,
                    direction: GradientDirection.Right,
                    colors: [[$r("app.color.DCEAF9"), 0.0], [$r("app.color.FAFAFA"), 1.0]]
                  } : {
                    angle: 90,
                    direction: GradientDirection.Right,
                    colors: [
                      [$r("sys.color.ohos_id_color_foreground_contrary"), 1],
                      [$r("sys.color.ohos_id_color_foreground_contrary"), 1]
                    ]
                  })
                }
                .height($r('app.float.wh_value_104'))
              }
              .width(WidthPercent.WH_100_100)
            }
            .backgroundColor($r("sys.color.ohos_id_color_sub_background"))
            .padding({ left: $r('app.float.wh_value_16'), right: $r('app.float.wh_value_16') })
            .width(WidthPercent.WH_100_100)
            .height(WidthPercent.WH_100_100)

          }
          .width(WidthPercent.WH_100_100)
          .height(WidthPercent.WH_100_100);
        }
      }
      .margin(vp2px(1) === 2 ? '24vp' : '0vp')
      .width(WidthPercent.WH_100_100)
      .height(WidthPercent.WH_100_100);
    }
    .backgroundColor($r("sys.color.ohos_id_color_sub_background"))
    .width(WidthPercent.WH_100_100)
    .height(WidthPercent.WH_100_100);
  }

  onPageShow() {
    let uri = GlobalContext.getContext().getAbilityWant().uri;
    GlobalContext.getContext().clearAbilityWantUri();

    if (uri === 'certInstall') {
      router.pushUrl({
        url: 'pages/certInstallFromStorage'
      })
    } else if (uri === 'requestAuthorize') {
      this.mFaPresenter.startRequestAuth(GlobalContext.getContext().getAbilityWant().parameters?.appUid as string);
    }
  }
}