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
import { AlertDialog, CustomContentDialog } from '@ohos.arkui.advanced.Dialog';
import { BusinessError } from '@ohos.base';
import CmShowSysCredPresenter from '../../presenter/CmShowSysCredPresenter';
import { SheetParam } from '../../common/util/SheetParam';
import { NavEntryKey } from '../../common/NavEntryKey';

const TAG: string = 'CredSystemDetailPage: ';

export class CredSystemDetailParam {
  public presenter: CmShowSysCredPresenter;

  constructor(presenter: CmShowSysCredPresenter) {
    this.presenter = presenter;
  }
}

@Component
export struct CredSystemDetailPage {
  private presenter: CmShowSysCredPresenter = CmShowSysCredPresenter.getInstance();

  private stack?: NavPathStack;

  @State private bottomRectHeight: number = 80;
  @State private headRectHeight: number = 64;
  @State private headRectHeightReal: number = 0;
  @Prop private sheetParam: SheetParam;

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
          this.presenter.deleteSystemCred(this.presenter.credInfo.keyUri);
          this.presenter.updateSystemCredList();
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
          }.zIndex(1)
          .onAreaChange((oldArea, newArea) => {
            this.headRectHeight = newArea.height as number;
            this.headRectHeightReal = newArea.height as number;
          })

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
    .height(this.sheetParam?.lastSheetPage === NavEntryKey.CRED_SYSTEM_DETAIL_ENTRY ?
      WidthPercent.WH_AUTO : this.sheetParam?.sheetMinHeight)
    .backgroundColor($r('sys.color.background_secondary'))
    .onReady((ctx: NavDestinationContext) => {
      this.stack = ctx.pathStack;
      try {
        this.presenter = (ctx.pathInfo.param as CredSystemDetailParam).presenter;
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