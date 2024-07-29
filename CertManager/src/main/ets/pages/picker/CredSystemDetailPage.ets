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

const TAG: string = 'CredSystemDetailPage: ';

export class CredSystemDetailParam {
  presenter: CmShowSysCredPresenter;

  constructor(presenter: CmShowSysCredPresenter) {
    this.presenter = presenter;
  }
}

@Component
export struct CredSystemDetailPage {
  private presenter: CmShowSysCredPresenter = CmShowSysCredPresenter.getInstance();

  private stack?: NavPathStack;

  @State private bottomRectHeight: Length = $r('sys.float.padding_level8');

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
        Column() {
          HeadComponent({ headName: $r('app.string.evidenceDetails'), isStartBySheet: true, onBackClicked: () => {
            this.stack?.pop();
          } })
            .margin({
              left: $r('app.float.wh_value_12'),
              top: 8
            })

          Scroll() {
            this.buildContent()
          }
          .align(Alignment.Top)
          .scrollable(ScrollDirection.Vertical)
          .scrollBar(BarState.Auto)
          .edgeEffect(EdgeEffect.Spring)
          .width(WidthPercent.WH_100_100)
          .layoutWeight(1)
        }
        .width(WidthPercent.WH_100_100)
        .height(WidthPercent.WH_100_100)
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
    .height(WidthPercent.WH_100_100)
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
}