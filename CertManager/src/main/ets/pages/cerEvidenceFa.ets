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

import { WidthPercent, LocationChoice, ConfigValue } from '../common/util/ConfigData';
import HeadComponent from '../common/component/headComponent';
import CmShowAppCredPresenter from '../presenter/CmShowAppCredPresenter';
import CMFaPresenter from '../presenter/CmFaPresenter';
import { GlobalContext } from '../common/GlobalContext';
import { CredentialAbstractVo } from '../model/CertManagerVo/CredentialAbstractVo';
import { AppAuthorVo } from '../model/CertManagerVo/AppAuthorVo';
import router from '@ohos.router';

@Component
export struct DialogComponent {
  @Link uidItem: CmShowAppCredPresenter;
  private appName: string = '';
  private appImage: string = '';
  private indexNum: number = 0;

  build() {
    Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
      Row() {
        Image(this.appImage)
          .width($r('app.float.credentials_app_image_wh'))
          .height($r('app.float.credentials_app_image_hg'))

        Text(this.appName)
          .fontSize($r('sys.float.ohos_id_text_size_body2'))
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .fontWeight(FontWeight.Medium)
          .margin({ left: $r('app.float.credentials_app_name_margin') })
      }
      .alignItems(VerticalAlign.Center)

      Toggle({ type: ToggleType.Switch, isOn: true })
        .width($r('app.float.credentials_app_Toggle_wh'))
        .height($r('app.float.credentials_app_Toggle_hg'))
        .selectedColor($r('app.color.credentials_app_Toggle_selectColor'))
        .onChange((isOn: boolean) => {
          this.uidItem.appInfoList[this.indexNum].status = isOn
        })
        .margin({ right: $r('app.float.wh_value_16') })

    }.height($r('app.float.wh_value_72'))
  }
}

@CustomDialog
@Component
struct CustomDialogExampleAuthor {
  controller?: CustomDialogController;
  @Link isShowAuthDialog: boolean;
  @Link authorInfo: CmShowAppCredPresenter;
  @State updateStatusList: boolean[] = [];
  private authorScroller: Scroller = new Scroller();

  build() {
    Column() {
      GridRow({ columns: 12, gutter: vp2px(1) === 2 ? '12vp' : '0vp', }) {
        GridCol({ span: { xs: 12, sm: 12, md: 12, lg: 8 }, offset: { xs: 0, sm: 0, md: 0, lg: 2 } }) {
          Column() {
            Text($r('app.string.managerAuthApp'))
              .height($r('app.float.wh_value_56'))
              .fontSize($r('sys.float.ohos_id_text_size_dialog_tittle'))
              .fontColor($r('sys.color.ohos_id_color_text_primary'))
              .fontWeight(FontWeight.Medium)
              .margin({
                left: $r('app.float.wh_value_24'),
                right: $r('app.float.wh_value_24')
              })
              .alignSelf(ItemAlign.Start);
            if (this.authorInfo.appInfoList.length > ConfigValue.APP_AUTH_MAX_LENGTH) {
              Stack({ alignContent: Alignment.End }) {
                Scroll(this.authorScroller) {
                  List() {
                    ForEach(this.authorInfo.appInfoList, (item: AppAuthorVo, index) => {
                      ListItem() {
                        DialogComponent({ appImage: item.appImage, appName: item.appName,
                          indexNum: index, uidItem: $authorInfo })
                      }
                    })
                  }
                  .scrollBar(BarState.Off)
                  .divider({
                    strokeWidth: $r('app.float.Evidence_strokeWidth'),
                    color: $r('app.color.Evidence_color') })
                  .backgroundColor($r('app.color.credentials_app_finish_backgroundColor'))
                  .visibility(this.authorInfo.appInfoList.length > 0 ? Visibility.Visible : Visibility.None)
                }
                .scrollBar(BarState.Off)
                .margin({
                  left: $r('app.float.wh_value_24'),
                  right: $r('app.float.wh_value_24')
                })

                ScrollBar({ scroller: this.authorScroller, direction: ScrollBarDirection.Vertical,
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
                ForEach(this.authorInfo.appInfoList, (item: AppAuthorVo, index) => {
                  ListItem() {
                    DialogComponent({ appImage: item.appImage, appName: item.appName,
                      indexNum: index, uidItem: $authorInfo })
                  }
                })
              }
              .scrollBar(BarState.Off)
              .margin({
                left: $r('app.float.wh_value_24'),
                right: $r('app.float.wh_value_24')
              })
              .divider({
                strokeWidth: $r('app.float.Evidence_strokeWidth'),
                color: $r('app.color.Evidence_color') })
              .backgroundColor($r('app.color.credentials_app_finish_backgroundColor'))
              .visibility(this.authorInfo.appInfoList.length > 0 ? Visibility.Visible : Visibility.None)
            }

            Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center,
              justifyContent: FlexAlign.SpaceAround }) {
              Button($r('app.string.cancelAuthApp'))
                .onClick(() => {
                  this.isShowAuthDialog = false;
                  if (this.controller !== undefined) {
                    this.controller.close();
                  }
                })
                .backgroundColor($r('app.color.credentials_app_finish_backgroundColor'))
                .fontSize($r('sys.float.ohos_id_text_size_button1'))
                .fontColor($r('sys.color.ohos_id_color_text_hyperlink'))
                .width($r('app.float.wh_value_152'))
                .height($r('app.float.wh_value_40'))
              Divider()
                .strokeWidth(ConfigValue.VERTICAL_DIVIDER_WIDTH)
                .color($r('sys.color.ohos_id_color_list_separator'))
                .vertical(true)
                .opacity($r('app.float.opacity_0_2'))
                .height($r('app.float.wh_value_40'))
              Button($r('app.string.finishAuthApp'))
                .onClick(() => {
                  this.authorInfo.removeGrantedAppList(this.authorInfo.credInfo.keyUri).then(() => {
                    this.isShowAuthDialog = false;
                    if (this.controller !== undefined) {
                      this.controller.close();
                    }
                  })
                })
                .backgroundColor($r('app.color.credentials_app_finish_backgroundColor'))
                .fontSize($r('sys.float.ohos_id_text_size_button1'))
                .fontColor($r('sys.color.ohos_id_color_text_hyperlink'))
                .width($r('app.float.wh_value_152'))
                .height($r('app.float.wh_value_40'))
            }
            .height($r('app.float.wh_value_64'))
            .padding({
              bottom: $r('app.float.wh_value_16')
            })
            .margin({
              top: $r('app.float.wh_value_6'),
              left: $r('app.float.wh_value_24'),
              right: $r('app.float.wh_value_24')
            })
          }
          .width(WidthPercent.WH_100_100)
          .borderRadius($r('app.float.user_list_divider_borderRadius_value'))
          .backgroundColor($r('sys.color.ohos_id_color_foreground_contrary'))
        }
      }.margin(vp2px(1) === 2 ? '24vp' : '0vp')
    }
    .margin({
      bottom: $r('sys.float.ohos_id_dialog_margin_bottom'),
      left: $r('sys.float.ohos_id_dialog_margin_start'),
      right: $r('sys.float.ohos_id_dialog_margin_end'),
    })
  }
}

@CustomDialog
@Component
struct CustomDialogDeleteWarning {
  controller?: CustomDialogController;
  @Link deleteWarn: CmShowAppCredPresenter;
  @Link isShowWarnDialog: boolean;

  build() {
    Column() {
      GridRow({ columns: 12, gutter: vp2px(1) === 2 ? '12vp' : '0vp', }) {
        GridCol({ span: { xs: 12, sm: 12, md: 12, lg: 8 }, offset: { xs: 0, sm: 0, md: 0, lg: 2 } }) {
          Column() {
            Text($r('app.string.warning_title'))
              .height($r('app.float.wh_value_56'))
              .fontSize($r('sys.float.ohos_id_text_size_dialog_tittle'))
              .fontColor($r('sys.color.ohos_id_color_text_primary'))
              .fontWeight(FontWeight.Medium)
              .margin({
                left: $r('app.float.wh_value_24'),
                right: $r('app.float.wh_value_24')
              })
              .alignSelf(ItemAlign.Start)
            Text($r('app.string.warning_message'))
              .fontSize($r('sys.float.ohos_id_text_size_body1'))
              .fontWeight(FontWeight.Regular)
              .fontColor($r('sys.color.ohos_id_color_primary'))
              .margin({
                top: $r('app.float.wh_value_16'),
                left: $r('app.float.wh_value_24'),
                right: $r('app.float.wh_value_24')
              })
              .alignSelf(ItemAlign.Start)

            Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center,
              justifyContent: FlexAlign.SpaceAround }) {
              Button($r('app.string.deleteAllCredCancel'))
                .onClick(() => {
                  this.isShowWarnDialog = false;
                  if (this.controller !== undefined) {
                    this.controller.close();
                  }
                })
                .backgroundColor($r('app.color.credentials_app_finish_backgroundColor'))
                .fontSize($r('sys.float.ohos_id_text_size_button1'))
                .fontColor($r('sys.color.ohos_id_color_text_hyperlink'))
                .width($r('app.float.wh_value_152'))
                .height($r('app.float.wh_value_40'))
              Divider()
                .strokeWidth(ConfigValue.VERTICAL_DIVIDER_WIDTH)
                .color($r('sys.color.ohos_id_color_list_separator'))
                .vertical(true)
                .height($r('app.float.wh_value_40'))
                .opacity($r('app.float.opacity_0_2'))
              Button($r('app.string.deleteAllCredDelete'))
                .onClick(() => {
                  this.deleteWarn.deleteAppCred(this.deleteWarn.credInfo.keyUri);
                  this.isShowWarnDialog = false;
                  if (this.controller !== undefined) {
                    this.controller.close();
                  }
                })
                .backgroundColor($r('app.color.credentials_app_finish_backgroundColor'))
                .fontSize($r('sys.float.ohos_id_text_size_button1'))
                .fontColor($r('sys.color.ohos_id_color_warning'))
                .width($r('app.float.wh_value_152'))
                .height($r('app.float.wh_value_40'))
            }
            .height($r('app.float.wh_value_64'))
            .padding({
              bottom: $r('app.float.wh_value_16')
            })
            .margin({
              top: $r('app.float.wh_value_16'),
              left: $r('app.float.wh_value_24'),
              right: $r('app.float.wh_value_24')
            })
          }
          .width(WidthPercent.WH_100_100)
          .borderRadius($r('app.float.user_list_divider_borderRadius_value'))
          .backgroundColor($r('sys.color.ohos_id_color_foreground_contrary'))
        }
      }.margin(vp2px(1) === 2 ? '24vp' : '0vp')
    }
    .margin({
      bottom: $r('sys.float.ohos_id_dialog_margin_bottom'),
      left: $r('sys.float.ohos_id_dialog_margin_start'),
      right: $r('sys.float.ohos_id_dialog_margin_end'),
    })
  }
}

@CustomDialog
@Component
struct CustomDialogExampleApp {
  controller?: CustomDialogController;
  @Link mShowAppCaPresenter: CmShowAppCredPresenter;
  @Link isShowAuthDialog: boolean;
  @Link isShowWarnDialog: boolean;

  aboutToAppear() {
    this.mShowAppCaPresenter.getAuthorizedAppList(this.mShowAppCaPresenter.credInfo.keyUri)
  }

  build() {
    Column() {
      GridRow({ columns: 12, gutter: vp2px(1) === 2 ? '12vp' : '0vp' }) {
        GridCol({ span: { xs: 12, sm: 12, md: 12, lg: 8 }, offset: { xs: 0, sm: 0, md: 0, lg: 2 } }) {
          Column() {
            Text($r('app.string.evidenceDetails'))
              .height($r('app.float.wh_value_56'))
              .fontSize($r('sys.float.ohos_id_text_size_dialog_tittle'))
              .fontColor($r('sys.color.ohos_id_color_text_primary'))
              .fontWeight(FontWeight.Medium)
              .margin({
                left: $r('app.float.wh_value_24'),
                right: $r('app.float.wh_value_24')
              })
              .alignSelf(ItemAlign.Start)

            Text(this.mShowAppCaPresenter.credInfo.alias)
              .fontSize($r('sys.float.ohos_id_text_size_body1'))
              .fontColor($r('sys.color.ohos_id_color_text_primary'))
              .fontWeight(FontWeight.Medium)
              .margin({
                left: $r('app.float.wh_value_24'),
                right: $r('app.float.wh_value_24')
              })
              .alignSelf(ItemAlign.Start)

            Text($r('app.string.entryContains'))
              .fontSize($r('sys.float.ohos_id_text_size_body2'))
              .fontColor($r('sys.color.ohos_id_color_text_primary'))
              .fontWeight(FontWeight.Regular)
              .margin({
                top: $r('app.float.wh_value_24'),
                left: $r('app.float.wh_value_24'),
                right: $r('app.float.wh_value_24')
              })
              .alignSelf(ItemAlign.Start)

            Text($r('app.string.keyNum', String(this.mShowAppCaPresenter.credInfo.keyNum)))
              .fontSize($r('sys.float.ohos_id_text_size_body2'))
              .fontColor($r('sys.color.ohos_id_color_text_primary'))
              .fontWeight(FontWeight.Regular)
              .margin({
                left: $r('app.float.wh_value_24'),
                right: $r('app.float.wh_value_24')
              })
              .opacity($r('app.float.opacity_100_60'))
              .alignSelf(ItemAlign.Start)

            Text($r('app.string.userCerNum', String(this.mShowAppCaPresenter.credInfo.certNum)))
              .fontSize($r('sys.float.ohos_id_text_size_body2'))
              .fontColor($r('sys.color.ohos_id_color_text_primary'))
              .fontWeight(FontWeight.Regular)
              .margin({
                left: $r('app.float.wh_value_24'),
                right: $r('app.float.wh_value_24')
              })
              .opacity($r('app.float.opacity_100_60'))
              .alignSelf(ItemAlign.Start)

            Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
              Column() {
                Text($r('app.string.managerAuthApp'))
                  .fontSize($r('sys.float.ohos_id_text_size_body1'))
                  .fontColor($r('sys.color.ohos_id_color_text_primary'))
                  .fontWeight(FontWeight.Medium)
              }

              Row() {
                Image($r('app.media.ic_settings_arrow'))
                  .width($r('app.float.managerAuthApp_image_wh'))
                  .height($r('app.float.managerAuthApp_image_hg'))
                  .fillColor($r('sys.color.ohos_id_color_primary'))
                  .opacity($r('app.float.managerAuthApp_image_opacity'))
              }
            }
            .onClick(() => {
              this.isShowAuthDialog = true;
            })
            .margin({
              top: $r('app.float.wh_value_12'),
              left: $r('app.float.wh_value_24'),
              right: $r('app.float.wh_value_24')
            })
            .height('48vp')

            Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center,
              justifyContent: FlexAlign.SpaceAround }) {
              Button($r('app.string.publicDetailsCancel'))
                .onClick(() => {
                  this.isShowAuthDialog = false;
                  this.isShowWarnDialog = false;
                  if (this.controller !== undefined) {
                    this.controller.close();
                  }
                })
                .backgroundColor($r('app.color.credentials_app_finish_backgroundColor'))
                .fontSize($r('sys.float.ohos_id_text_size_button1'))
                .fontColor($r('sys.color.ohos_id_color_text_hyperlink'))
                .width($r('app.float.wh_value_152'))
                .height($r('app.float.wh_value_40'))
              Divider()
                .strokeWidth(ConfigValue.VERTICAL_DIVIDER_WIDTH)
                .color($r('sys.color.ohos_id_color_list_separator'))
                .vertical(true)
                .height($r('app.float.wh_value_40'))
                .opacity($r('app.float.opacity_0_2'))
              Button($r('app.string.publicDetailsDelete'))
                .onClick(() => {
                  this.isShowWarnDialog = true;
                  this.isShowAuthDialog = false;
                  if (this.controller !== undefined) {
                    this.controller.close();
                  }
                })
                .backgroundColor($r('app.color.credentials_app_finish_backgroundColor'))
                .fontSize($r('sys.float.ohos_id_text_size_button1'))
                .fontColor($r('sys.color.ohos_id_color_warning'))
                .width($r('app.float.wh_value_152'))
                .height($r('app.float.wh_value_40'))
            }
            .height($r('app.float.wh_value_64'))
            .padding({
              bottom: $r('app.float.wh_value_16')
            })
            .margin({
              top: $r('app.float.wh_value_16'),
              left: $r('app.float.wh_value_24'),
              right: $r('app.float.wh_value_24')
            })
          }
          .width(WidthPercent.WH_100_100)
          .borderRadius($r('app.float.user_list_divider_borderRadius_value'))
          .backgroundColor($r('sys.color.ohos_id_color_foreground_contrary'))
        }
      }.margin(vp2px(1) === 2 ? '24vp' : '0vp')
    }
    .margin({
      bottom: $r('sys.float.ohos_id_dialog_margin_bottom'),
      left: $r('sys.float.ohos_id_dialog_margin_start'),
      right: $r('sys.float.ohos_id_dialog_margin_end'),
    })
  }
}

@Component
export struct componentPublic {
  private alias: string = '';
  private keyUri: string = '';
  @Link mShowAppCaPresenter: CmShowAppCredPresenter;
  @State @Watch('onShowAuthMngChange') isShowAuthMng: boolean = false;
  @State @Watch('onShowDeleteWarnDialog') isShowWarning: boolean = false;

  detailsDialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogExampleApp({
      isShowAuthDialog: $isShowAuthMng,
      isShowWarnDialog: $isShowWarning,
      mShowAppCaPresenter: $mShowAppCaPresenter
    }),
    autoCancel: true,
    customStyle: true,
  })

  appDialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogExampleAuthor({ isShowAuthDialog: $isShowAuthMng, authorInfo: $mShowAppCaPresenter }),
    autoCancel: false,
    customStyle: true,
  })

  deleteWarnDialog: CustomDialogController = new CustomDialogController({
    builder: CustomDialogDeleteWarning({ isShowWarnDialog: $isShowWarning, deleteWarn: $mShowAppCaPresenter }),
    autoCancel: false,
    customStyle: true,
  })

  onShowAuthMngChange() {
    if (this.isShowAuthMng == true) {
      this.appDialogController.open();
    } else {
      this.detailsDialogController.close();
      this.detailsDialogController.open();
      this.appDialogController.close();
    }
  }

  onShowDeleteWarnDialog() {
    if (this.isShowWarning == true) {
      this.deleteWarnDialog.open();
    } else {
      this.detailsDialogController.close();
      this.deleteWarnDialog.close();
    }
  }

  build() {
    Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
      Column() {
        Text(this.alias)
          .fontSize($r('sys.float.ohos_id_text_size_body1'))
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .fontWeight(FontWeight.Medium)
      }

      Row() {
        Image($r('app.media.ic_settings_arrow'))
          .width($r('app.float.publicList_image_wh'))
          .height($r('app.float.publicList_image_hg'))
      }
    }
    .height($r('app.float.wh_value_48'))
    .onClick(() => {
      this.mShowAppCaPresenter.getAppCred(this.keyUri, () => {
        this.detailsDialogController.open();
      });
    })
  }
}

@Entry
@Component
struct evidenceList {
  @State mShowAppCaPresenter: CmShowAppCredPresenter = CmShowAppCredPresenter.getInstance();
  @State mFaPresenter: CMFaPresenter = CMFaPresenter.getInstance();
  @State isTouched: boolean = false;
  @State currentIndex: number = 0
  @State fontColor: Resource = $r('app.color.evidenceList_TabBuilder_fontColor_182431')
  private publicScroller: Scroller = new Scroller();

  aboutToAppear() {
    console.info('in aboutToAppear');
    this.mShowAppCaPresenter.updateAppCredListCallback(() => {
      console.info('get AppCredList first');
    })
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

  build() {
    Column() {
      GridRow({ columns: 12, gutter: vp2px(1) === 2 ? '12vp' : '0vp' }) {
        GridCol({ span: { xs: 12, sm: 12, md: 12, lg: 8 }, offset: { xs: 0, sm: 0, md: 0, lg: 2 } }) {
          Row() {
            Column() {
              HeadComponent({ headName: $r('app.string.userEvidence') })
                .margin({
                  left: $r('app.float.wh_value_16')
                })

              Column() {
                Stack({ alignContent: Alignment.End }) {
                  Scroll(this.publicScroller) {
                    List() {
                      ForEach(this.mShowAppCaPresenter.credList, (item: CredentialAbstractVo) => {
                        ListItem() {
                          componentPublic({
                            alias: item.alias,
                            keyUri: item.keyUri,
                            mShowAppCaPresenter: $mShowAppCaPresenter
                          })
                        }
                      }, (item: CredentialAbstractVo) => JSON.stringify(item))
                    }
                    .scrollBar(BarState.Off)
                    .padding({
                      right: $r('app.float.wh_value_12'),
                      left: $r('app.float.wh_value_12'),
                      top: $r('app.float.wh_value_4'),
                      bottom: $r('app.float.wh_value_4')
                    })
                    .divider({
                      strokeWidth: $r('app.float.user_list_divider_strokeWidth_value'),
                      color: $r('app.color.user_list_divider_color_000000'),
                      endMargin: '3vp'
                    })
                    .visibility(this.mShowAppCaPresenter.credList.length > 0 ? Visibility.Visible : Visibility.None)
                  }
                  .position({ y: 0 })
                  .scrollable(ScrollDirection.Vertical)
                  .scrollBar(BarState.Off)
                  .margin({
                    left: $r('app.float.wh_value_12'),
                    right: $r('app.float.wh_value_12')
                  })
                  .borderRadius($r('app.float.Evidence_borderRadius'))
                  .backgroundColor($r('app.color.credentials_app_finish_backgroundColor'))

                  ScrollBar({ scroller: this.publicScroller, direction: ScrollBarDirection.Vertical,
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
                  .visibility(this.mShowAppCaPresenter.credList.length > 0 ? Visibility.Visible : Visibility.None)
                }
                .width(WidthPercent.WH_100_100)
                .margin({
                  bottom: $r('app.float.wh_value_24')
                })
                .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
              }
              .height(WidthPercent.WH_94_100)
              .width(WidthPercent.WH_100_100)
            }
            .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
            .width(WidthPercent.WH_100_100)
            .height(WidthPercent.WH_100_100)
          }
          .width(WidthPercent.WH_100_100)
          .height(WidthPercent.WH_100_100);
        }
        .margin(vp2px(1) === 2 ? '24vp' : '0vp')
      }
      .width(WidthPercent.WH_100_100)
      .height(WidthPercent.WH_100_100);
    }
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
    .width(WidthPercent.WH_100_100)
    .height(WidthPercent.WH_100_100);
  }
}
