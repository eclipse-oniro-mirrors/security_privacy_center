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

import { WidthPercent, ConfigValue } from '../common/util/ConfigData';
import HeadComponent from '../common/component/headComponent';
import CmShowAppCredPresenter from '../presenter/CmShowAppCredPresenter';
import CMFaPresenter from '../presenter/CmFaPresenter';
import { GlobalContext } from '../common/GlobalContext';
import { CredentialAbstractVo } from '../model/CertManagerVo/CredentialAbstractVo';
import { AppAuthorVo } from '../model/CertManagerVo/AppAuthorVo';
import router from '@ohos.router';
import { CustomContentDialog } from '@ohos.arkui.advanced.Dialog';

const COPIES_NUM: number = 12;

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

@Component
export struct componentPublic {
  private alias: string = '';
  private keyUri: string = '';
  @Link mShowAppCaPresenter: CmShowAppCredPresenter;
  @State authorInfo: CmShowAppCredPresenter = CmShowAppCredPresenter.getInstance();
  private authorScroller: Scroller = new Scroller();
  @State isHoverBackgroundColor: ResourceColor = '';
  @Styles pressedStyles(): void {
    .backgroundColor($r('sys.color.ohos_id_color_click_effect'))
  }
  @Styles normalStyles(): void {
    .backgroundColor(this.isHoverBackgroundColor)
  }

  aboutToAppear() {
    this.mShowAppCaPresenter.updateAppCredList();
  }

  getAuthorizedAppList(): void {
    this.authorInfo.getAuthorizedAppList(this.mShowAppCaPresenter.credInfo.keyUri);
  }

  deleteWarnDialog: CustomDialogController = new CustomDialogController({
    builder: CustomContentDialog({
      contentBuilder: () => {
        this.deleteWarnContent();
      },
      contentAreaPadding: { right: $r('app.float.wh_value_0') },
      buttons: [
        {
          value: $r('app.string.cancelAuthApp'),
          buttonStyle: ButtonStyleMode.TEXTUAL,
          action: () => {
            this.appDialogController?.close();
          }
        },
        {
          value: $r('app.string.deleteAllCredDelete'),
          buttonStyle: ButtonStyleMode.TEXTUAL,
          action: () => {
            this.mShowAppCaPresenter.deleteAppCred(this.mShowAppCaPresenter.credInfo.keyUri);
            this.deleteWarnDialog?.close();
          },
          role: ButtonRole.ERROR
        }
      ]
    }),
  })

  appDialogController: CustomDialogController = new CustomDialogController({
    builder: CustomContentDialog({
      contentBuilder: () => {
        this.appControllerContent();
      },
      contentAreaPadding: { right: $r('app.float.wh_value_0') },
      buttons: [
        {
          value: $r('app.string.cancelAuthApp'),
          buttonStyle: ButtonStyleMode.TEXTUAL,
          action: () => {
            this.appDialogController?.close();
          }
        },
        {
          value: $r('app.string.finishAuthApp'),
          buttonStyle: ButtonStyleMode.TEXTUAL,
          action: () => {
            this.authorInfo.removeGrantedAppList(this.authorInfo.credInfo.keyUri).then(() => {
              this.appDialogController?.close();
            })
          }
        }
      ]
    }),
  })

  credDetailsDialog: CustomDialogController = new CustomDialogController({
    builder: CustomContentDialog({
      contentBuilder: () => {
        this.credDetailContent();
      },
      contentAreaPadding: { right: $r('app.float.wh_value_0') },
      buttons: [
        {
          value: $r('app.string.publicDetailsCancel'),
          buttonStyle: ButtonStyleMode.TEXTUAL,
          action: () => {
            this.credDetailsDialog?.close();
          }
        },
        {
          value: $r('app.string.publicDetailsDelete'),
          buttonStyle: ButtonStyleMode.TEXTUAL,
          action: () => {
            this.onShowDeleteWarnDialog();
          },
          role: ButtonRole.ERROR
        }
      ]
    }),
  })

  @Builder
  appControllerContent(): void {
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
        .alignSelf(ItemAlign.Start)

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
              color: $r('sys.color.ohos_id_color_list_separator')
            })
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
              .opacity($r('app.float.text_opacity_0_4'))
          }
          .width($r('app.float.wh_value_3'))
          .margin({
            right: $r('app.float.wh_value_3')
          })
        }
        .height(WidthPercent.WH_50_100)
      } else {
        List() {
          ForEach(this.mShowAppCaPresenter.appInfoList, (item: AppAuthorVo, index) => {
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
          color: $r('sys.color.ohos_id_color_list_separator')
        })
        .visibility(this.authorInfo.appInfoList.length > 0 ? Visibility.Visible : Visibility.None)
      }
    }
    .width(WidthPercent.WH_100_100)
    .borderRadius($r('app.float.user_list_divider_borderRadius_value'))
    .backgroundColor($r('sys.color.ohos_id_color_dialog_bg'))
  }

  @Builder
  credDetailContent(): void {
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
        this.onShowAuthMngChange();
      })
      .margin({
        top: $r('app.float.wh_value_12'),
        left: $r('app.float.wh_value_24'),
        right: $r('app.float.wh_value_24')
      })
      .height('48vp')
    }
    .width(WidthPercent.WH_100_100)
    .borderRadius($r('app.float.user_list_divider_borderRadius_value'))
    .backgroundColor($r('sys.color.ohos_id_color_dialog_bg'))
  }

  @Builder
  deleteWarnContent(): void {
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
    }
    .width(WidthPercent.WH_100_100)
    .borderRadius($r('app.float.user_list_divider_borderRadius_value'))
    .backgroundColor($r('sys.color.ohos_id_color_dialog_bg'))
  }

  onShowAuthMngChange() {
    this.credDetailsDialog?.close();
    this.appDialogController.open();
  }

  onShowDeleteWarnDialog() {
    this.credDetailsDialog?.close();
    this.deleteWarnDialog.open();
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
    .hoverEffect(HoverEffect.Highlight)
    .onHover((isHover?: boolean) => {
      this.isHoverBackgroundColor = isHover ? $r('sys.color.ohos_id_color_hover') : ''
    })
    .backgroundColor(this.isHoverBackgroundColor)
    .stateStyles({
      pressed: this.pressedStyles,
      normal: this.normalStyles
    })
    .onClick(() => {
      this.mShowAppCaPresenter.getAppCred(this.keyUri, () => {
        this.getAuthorizedAppList();
        this.credDetailsDialog.open();
      });
    })
  }
}

@Entry
@Component
struct evidenceList {
  @State mShowAppCaPresenter: CmShowAppCredPresenter = CmShowAppCredPresenter.getInstance();
  @State mFaPresenter: CMFaPresenter = CMFaPresenter.getInstance();
  private publicScroller: Scroller = new Scroller();

  @Styles normalStyle() {
    .backgroundColor($r('sys.color.ohos_id_color_card_bg'))
    .borderRadius($r('app.float.wh_value_10'))
  };

  @Styles pressedStyle() {
    .backgroundColor($r('sys.color.ohos_id_color_click_effect'))
    .borderRadius($r('app.float.wh_value_10'))
  };

  aboutToAppear() {
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
    } else {
      console.info('The want type is not supported.');
    }
  }

  build() {
    Column() {
      GridRow({
        columns: COPIES_NUM,
        gutter: vp2px(1) === 2 ? $r('app.float.wh_value_12') : $r('app.float.wh_value_0')
      }) {
        GridCol({ span: { xs: COPIES_NUM, sm: COPIES_NUM, md: COPIES_NUM, lg: COPIES_NUM },
          offset: { xs: 0, sm: 0, md: 0, lg: 0 } }) {
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
                        .stateStyles({
                          normal: this.normalStyle,
                          pressed: this.pressedStyle
                        });
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
                      color: $r('sys.color.ohos_id_color_list_separator'),
                      endMargin: $r('app.float.wh_value_3')
                    })
                    .visibility(this.mShowAppCaPresenter.credList.length > 0 ? Visibility.Visible : Visibility.None)
                  }
                  .position({ y: $r('app.float.wh_value_0') })
                  .scrollable(ScrollDirection.Vertical)
                  .scrollBar(BarState.Off)
                  .margin({
                    left: $r('app.float.wh_value_12'),
                    right: $r('app.float.wh_value_12')
                  })
                  .borderRadius($r('app.float.Evidence_borderRadius'))
                  .backgroundColor($r('sys.color.ohos_id_color_list_card_bg'))

                  ScrollBar({ scroller: this.publicScroller, direction: ScrollBarDirection.Vertical,
                    state: BarState.Auto }) {
                    Text()
                      .width($r('app.float.wh_value_3'))
                      .height($r('app.float.wh_value_50'))
                      .borderRadius($r('app.float.wh_value_10'))
                      .backgroundColor($r('sys.color.ohos_id_color_foreground'))
                      .opacity($r('app.float.text_opacity_0_4'))
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
        .margin(vp2px(1) === 2 ? $r('app.float.item_common_horizontal_margin') : $r('app.float.wh_value_0'))
      }
      .width(WidthPercent.WH_100_100)
      .height(WidthPercent.WH_100_100);
    }
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
    .width(WidthPercent.WH_100_100)
    .height(WidthPercent.WH_100_100);
  }
}
