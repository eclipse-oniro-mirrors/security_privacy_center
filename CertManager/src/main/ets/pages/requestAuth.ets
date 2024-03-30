/**
 * Copyright (c) 2022-2024 Huawei Device Co., Ltd.
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

import CmAppCredAuthPresenter from '../presenter/CmAppCredAuthPresenter';
import router from '@ohos.router';
import { WidthPercent, ConfigValue } from '../common/util/ConfigData';
import { CredentialAbstractVo } from '../model/CertManagerVo/CredentialAbstractVo';
import { RouterAppUidVo } from '../model/CertManagerVo/RouterInfoVo';

@CustomDialog
@Component
struct CustomDialogAuthForApp {
  controller?: CustomDialogController
  @State mAppCredAuthPresenter: CmAppCredAuthPresenter = CmAppCredAuthPresenter.getInstance();
  selectUri: string = '';
  private authScroller: Scroller = new Scroller();

  aboutToAppear(): void {
    console.info('certPwdInput about to appear');
    let appUidInfo: RouterAppUidVo = router.getParams() as RouterAppUidVo;
    this.mAppCredAuthPresenter.updateAppNameFromUid(appUidInfo.appUid as string);
    this.mAppCredAuthPresenter.updateAppCredList();
  }

  build() {
    Column() {
      GridRow({ columns: 12, gutter: vp2px(1) === 2 ? '12vp' : '0vp' }) {
        GridCol({ span: { xs: 12, sm: 12, md: 12, lg: 8 }, offset: { xs: 0, sm: 0, md: 0, lg: 2 } }) {
          Row({}) {
            Column() {
              Text($r('app.string.pickCredToAuth'))
                .fontSize($r('sys.float.ohos_id_text_size_dialog_tittle'))
                .height($r('app.float.wh_value_56'))
                .fontColor($r('sys.color.ohos_id_color_text_primary'))
                .fontWeight(FontWeight.Medium)
                .margin({
                  left: $r('app.float.wh_value_24'),
                  right: $r('app.float.wh_value_24')
                })
                .alignSelf(ItemAlign.Start)

              Text($r('app.string.requestAuthMsg', this.mAppCredAuthPresenter.appName))
                .fontSize($r('sys.float.ohos_id_text_size_body1'))
                .fontColor($r('sys.color.ohos_id_color_text_primary'))
                .fontWeight(FontWeight.Regular)
                .margin({
                  top: $r('app.float.wh_value_8'),
                  left: $r('app.float.wh_value_24'),
                  right: $r('app.float.wh_value_24')
                })
                .alignSelf(ItemAlign.Start)

              if (this.mAppCredAuthPresenter.credList.length > ConfigValue.REQUEST_AUTH_MAX_LENGTH) {
                Stack({ alignContent: Alignment.End }) {
                  Scroll(this.authScroller) {
                    List() {
                      ForEach(this.mAppCredAuthPresenter.credList, (item: CredentialAbstractVo) => {
                        ListItem() {
                          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {

                            Column() {
                              Text(item.alias)
                                .fontSize($r('app.float.font_18'))
                                .fontColor($r('app.color.request_auth_font_color'))
                                .fontWeight(FontWeight.Medium)
                                .textAlign(TextAlign.Start);
                            }
                            .alignItems(HorizontalAlign.Start)

                            Column() {
                              Radio({ value: item.alias, group: 'appCredGroup' })
                                .checked(false)
                                .onChange((value: boolean) => {
                                  console.log(item.alias + ' status is ' + value)
                                  if (value) {
                                    this.selectUri = item.keyUri;
                                    console.log('selectUri is ' + this.selectUri)
                                  }
                                })
                            }
                            .alignItems(HorizontalAlign.End)
                          }
                          .width(WidthPercent.WH_100_100)
                        }
                        .height($r('app.float.wh_value_64'))
                      }, (item: CredentialAbstractVo) => JSON.stringify(item))
                    }
                    .scrollBar(BarState.Off)
                    .divider({
                      strokeWidth: $r('app.float.request_auth_strokeWidth'),
                      color: $r('app.color.request_auth_color'),
                      endMargin: $r('app.float.request_auth_divider_endMargin') })
                    .backgroundColor($r('app.color.request_auth_background_color'))
                    .visibility(this.mAppCredAuthPresenter.credList.length > 0 ? Visibility.Visible : Visibility.None)
                  }
                  .scrollBar(BarState.Off)
                  .margin({
                    left: $r('app.float.wh_value_24'),
                    right: $r('app.float.wh_value_24')
                  })

                  ScrollBar({ scroller: this.authScroller, direction: ScrollBarDirection.Vertical,
                    state: BarState.Auto }) {
                    Text()
                      .width($r('app.float.wh_value_3'))
                      .height($r('app.float.wh_value_50'))
                      .borderRadius($r('app.float.wh_value_10'))
                      .backgroundColor($r('sys.color.ohos_id_color_foreground'))
                      .opacity(0.4)
                  }
                  .width($r('app.float.wh_value_3'))
                  .margin({
                    right: $r('app.float.wh_value_3')
                  })
                }
                .height(WidthPercent.WH_50_100)
              } else {
                List() {
                  ForEach(this.mAppCredAuthPresenter.credList, (item: CredentialAbstractVo) => {
                    ListItem() {
                      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
                        Column() {
                          Text(item.alias)
                            .fontSize($r('app.float.font_18'))
                            .fontColor($r('app.color.request_auth_font_color'))
                            .fontWeight(FontWeight.Medium)
                            .textAlign(TextAlign.Start);
                        }
                        .alignItems(HorizontalAlign.Start)

                        Column() {
                          Radio({ value: item.alias, group: 'appCredGroup' })
                            .checked(false)
                            .onChange((value: boolean) => {
                              console.log(item.alias + ' status is ' + value)
                              if (value) {
                                this.selectUri = item.keyUri;
                                console.log('selectUri is ' + this.selectUri)
                              }
                            })
                        }
                        .alignItems(HorizontalAlign.End)
                      }
                      .width(WidthPercent.WH_100_100)
                    }
                    .height($r('app.float.wh_value_64'))
                  }, (item: CredentialAbstractVo) => JSON.stringify(item))
                  ListItem() {
                    Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
                      Column() {
                        Text()
                      }
                      .alignItems(HorizontalAlign.Start)

                      Column() {
                        Radio({ value: 'null', group: 'appCredGroup' })
                          .checked(false)
                          .onChange((value: boolean) => {
                            if (value) {
                              this.selectUri = 'null';
                              console.log('selectUri is ' + this.selectUri)
                            }
                          })
                      }
                    }
                    .visibility(Visibility.None)
                  }
                }
                .margin({
                  left: $r('app.float.wh_value_24'),
                  right: $r('app.float.wh_value_24')
                })
                .scrollBar(BarState.Off)
                .divider({
                  strokeWidth: $r('app.float.request_auth_strokeWidth'),
                  color: $r('app.color.request_auth_color'),
                  endMargin: $r('app.float.request_auth_divider_endMargin') })
                .backgroundColor($r('app.color.request_auth_background_color'))
                .visibility(this.mAppCredAuthPresenter.credList.length > 0 ? Visibility.Visible : Visibility.None)
              }

              Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center,
                justifyContent: FlexAlign.SpaceAround }) {
                Button($r('app.string.requestAuthCancel'))
                  .onClick(() => {
                    this.mAppCredAuthPresenter.cancelProcess();
                    if (this.controller !== undefined) {
                      this.controller.close();
                    }
                  })
                  .backgroundColor($r('app.color.request_auth_background_color'))
                  .fontColor($r('sys.color.ohos_id_color_text_hyperlink'))
                  .fontSize($r('sys.float.ohos_id_text_size_button1'))
                  .width($r('app.float.wh_value_152'))
                  .height($r('app.float.wh_value_40'))

                Divider()
                  .strokeWidth(ConfigValue.VERTICAL_DIVIDER_WIDTH)
                  .color($r('sys.color.ohos_id_color_list_separator'))
                  .vertical(true)
                  .height($r('app.float.wh_value_40'))
                  .opacity($r('app.float.opacity_0_2'))

                Button($r('app.string.requestAuthFinish'))
                  .onClick(() => {
                    console.info('requestAuthorize uri: ' + this.selectUri);
                    let appUidInfo: RouterAppUidVo = router.getParams() as RouterAppUidVo;
                    if (appUidInfo !== undefined && appUidInfo.appUid != undefined) {
                      console.info('requestAuthorize appUid: ' + appUidInfo.appUid);
                      this.mAppCredAuthPresenter.requestAuthorize(this.selectUri, appUidInfo.appUid);
                      if (this.controller !== undefined) {
                        this.controller.close();
                      }
                    } else {
                      console.info('requestAuthorize fail');
                    }
                  })
                  .backgroundColor($r('app.color.request_auth_background_color'))
                  .fontColor($r('sys.color.ohos_id_color_text_hyperlink'))
                  .fontSize($r('sys.float.ohos_id_text_size_button1'))
                  .width($r('app.float.wh_value_152'))
                  .height($r('app.float.wh_value_40'))
              }
              .height($r('app.float.wh_value_64'))
              .padding({
                bottom: $r('app.float.wh_value_16')
              })
              .margin({
                left: $r('app.float.wh_value_24'),
                right: $r('app.float.wh_value_24')
              })
            }
            .width(WidthPercent.WH_100_100)
            .borderRadius($r('app.float.user_list_divider_borderRadius_value'))
            .backgroundColor($r('sys.color.ohos_id_color_foreground_contrary'))
          }
        }
      }
      .margin(vp2px(1) === 2 ? '24vp' : '0vp')
    }
    .margin({
      bottom: $r('sys.float.ohos_id_dialog_margin_bottom'),
      left: $r('sys.float.ohos_id_dialog_margin_start'),
      right: $r('sys.float.ohos_id_dialog_margin_end'),
    })
  }
}

@Entry
@Component
struct RadioAuth {
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogAuthForApp(),
    autoCancel: false,
    alignment: DialogAlignment.Bottom,
    customStyle: true,
  })

  aboutToAppear() {
    console.info('RadioAuth aboutToAppear');
    let appUidInfo: RouterAppUidVo = router.getParams() as RouterAppUidVo;
    if (appUidInfo !== undefined && appUidInfo.appUid != undefined) {
      this.dialogController.open();
    } else {
      console.error('request auth appear failed');
      router.replaceUrl({ url: 'pages/certManagerFa' });
    }
  }

  build() {
  }
}
