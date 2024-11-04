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

import HeadComponent from '../../common/component/headComponent';
import { WidthPercent } from '../../common/util/ConfigData';
import { AlertDialog } from '@ohos.arkui.advanced.Dialog';
import { BusinessError } from '@ohos.base';
import CmShowAppCredPresenter from '../../presenter/CmShowAppCredPresenter';
import { NavEntryKey } from '../../common/NavEntryKey';
import { AuthorizedAppManagementParam } from './AuthorizedAppManagementPage';
import { SheetParam } from '../../common/util/SheetParam';

const TAG: string = 'CredUserDetailPage: ';

export class CredUserDetailParam {
  public presenter: CmShowAppCredPresenter;

  constructor(presenter: CmShowAppCredPresenter) {
    this.presenter = presenter;
  }
}

@Component
export struct CredUserDetailPage {
  private presenter: CmShowAppCredPresenter = CmShowAppCredPresenter.getInstance();

  private stack?: NavPathStack;

  @State private bottomRectHeight: number = 80;
  @State private headRectHeight: number = 64;
  @State private headRectHeightReal: number = 0;
  @Prop private sheetParam: SheetParam;

  @State private itemBackgroundColor: ResourceColor = '';

  @Styles pressedStyles(): void { .backgroundColor($r('sys.color.ohos_id_color_click_effect')) }

  @Styles normalStyles(): void { .backgroundColor(this.itemBackgroundColor) }

  deleteWarnDialog: CustomDialogController = new CustomDialogController({
    builder: AlertDialog({
      primaryTitle: $r('app.string.warning_title'),
      content: $r('app.string.warning_message'),
      primaryButton: {
        value: $r('app.string.cancelAuthApp'),
        buttonStyle: ButtonStyleMode.TEXTUAL,
        action: () => {
        }
      },
      secondaryButton: {
        value: $r('app.string.deleteAllCredDelete'),
        buttonStyle: ButtonStyleMode.TEXTUAL,
        action: () => {
          this.presenter.deleteAppCred(this.presenter.credInfo.keyUri);
          this.stack?.pop();
        },
        role: ButtonRole.ERROR
      }
    }),
  })

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.Bottom }) {
        Stack({ alignContent: Alignment.Top }) {
          Column() {
            HeadComponent({ headName: $r('app.string.evidenceDetails'), isStartBySheet: true, onBackClicked: () => {
              this.stack?.pop();
            } })
              .margin({
                left: $r('app.float.wh_value_12'),
                top: 8
              })
          }.onAreaChange((oldArea, newArea) => {
            this.headRectHeight = newArea.height as number;
            this.headRectHeightReal = newArea.height as number;
          }).zIndex(1)

          Column() {
            Scroll() {
              this.buildContent()
            }
            .align(Alignment.Top)
            .scrollable(ScrollDirection.Vertical)
            .scrollBar(BarState.Auto)
            .edgeEffect(EdgeEffect.Spring)
            .width(WidthPercent.WH_100_100)
            .height(WidthPercent.WH_AUTO)
            .constraintSize({
              minHeight: this.getScrollMinHeight()
            })
          }.padding({
            top: this.headRectHeight
          })
        }
        .width(WidthPercent.WH_100_100)
        .height(WidthPercent.WH_AUTO)
        .padding({
          bottom: this.bottomRectHeight
        })

        Column() {
          Button($r('app.string.warning_title'))
            .onClick(() => {
              this.deleteWarnDialog.open();
            })
            .role(ButtonRole.ERROR)
            .buttonStyle(ButtonStyleMode.NORMAL)
            .margin({
              top: $r('app.float.distance_16'),
              bottom: $r('app.float.distance_24')
            })
            .width(WidthPercent.WH_100_100)
            .constraintSize({
              minHeight: $r('app.float.wh_value_40')
            })
        }.onAreaChange((oldArea: Area, newArea: Area) => {
          this.bottomRectHeight = newArea.height as number;
        })
        .padding({
          left: 16, right: 16
        })
      }
    }
    .hideTitleBar(true)
    .width(WidthPercent.WH_100_100)
    .height(this.sheetParam?.lastSheetPage === NavEntryKey.CRED_USER_DETAIL_ENTRY ?
      WidthPercent.WH_AUTO : this.sheetParam?.sheetMinHeight)
    .backgroundColor($r('sys.color.background_secondary'))
    .onReady((ctx: NavDestinationContext) => {
      this.stack = ctx.pathStack;
      try {
        this.presenter = (ctx.pathInfo.param as CredUserDetailParam).presenter;
      } catch (err) {
        let error = err as BusinessError;
        console.error(TAG + 'Get presenter failed: ' + error?.code + ', message: ' + error?.message);
      }
    })
  }

  @Builder
  private buildContent() {
    Column() {
      Text(this.presenter.credInfo.alias)
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

      Text($r('app.string.keyNum', String(this.presenter.credInfo.keyNum)))
        .fontSize($r('sys.float.ohos_id_text_size_body2'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(FontWeight.Regular)
        .margin({
          left: $r('app.float.wh_value_10'),
          right: $r('app.float.wh_value_10')
        })
        .opacity($r('app.float.opacity_100_60'))
        .alignSelf(ItemAlign.Start)

      Text($r('app.string.userCerNum', String(this.presenter.credInfo.certNum)))
        .fontSize($r('sys.float.ohos_id_text_size_body2'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(FontWeight.Regular)
        .margin({
          left: $r('app.float.wh_value_10'),
          right: $r('app.float.wh_value_10')
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
        this.stack?.pushPath(new NavPathInfo(NavEntryKey.AUTHORIZED_APP_ENTRY,
          new AuthorizedAppManagementParam(this.presenter)));
      })
      .margin({
        top: $r('app.float.wh_value_12'),
        left: $r('app.float.wh_value_16'),
        right: $r('app.float.wh_value_16')
      })
      .borderRadius($r('sys.float.corner_radius_level8'))
      .backgroundColor(this.itemBackgroundColor)
      .onHover((isHover?: boolean) => {
        this.itemBackgroundColor = isHover ? $r('sys.color.ohos_id_color_hover') : '';
      })
      .stateStyles({
        pressed: this.pressedStyles,
        normal: this.normalStyles
      })
      .padding($r('app.float.wh_value_8'))
      .constraintSize({
        minHeight: $r('app.float.wh_value_48')
      })
    }
    .width(WidthPercent.WH_100_100)
    .alignItems(HorizontalAlign.Start)
  }

  getScrollMinHeight() {
    if (this.sheetParam === undefined || this.headRectHeightReal === 0 ||
      this.sheetParam.sheetMinHeight < (this.headRectHeightReal + this.bottomRectHeight)) {
      return 0;
    }
    return this.sheetParam.sheetMinHeight - this.headRectHeightReal - this.bottomRectHeight;
  }
}