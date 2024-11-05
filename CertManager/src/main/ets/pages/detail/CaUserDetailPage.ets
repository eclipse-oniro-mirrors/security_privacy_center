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
import CmShowUserCaPresenter from '../../presenter/CmShowUserCaPresenter';
import {
  DialogDateComponent,
  DialogFingerPrintComponent,
  DialogIssuerComponent,
  DialogSubjectComponent
} from './CaSystemDetailPage';
import { AlertDialog } from '@ohos.arkui.advanced.Dialog';
import { BusinessError } from '@ohos.base';
import { SheetParam } from '../../common/util/SheetParam';
import { NavEntryKey } from '../../common/NavEntryKey';

const TAG: string = 'CaUserDetailPage: ';

export class CaUserDetailParam {
  public showUserCaPresenter: CmShowUserCaPresenter;

  constructor(presenter: CmShowUserCaPresenter) {
    this.showUserCaPresenter = presenter;
  }
}

@Component
export struct CaUserDetailPage {
  private showUserCaPresenter: CmShowUserCaPresenter = CmShowUserCaPresenter.getInstance();

  private stack?: NavPathStack;

  @State private bottomRectHeight: number = 80;
  @State private headRectHeight: number = 64;
  @State private headRectHeightReal: number = 0;

  @State toggleStatus: boolean = false;
  @Prop sheetParam: SheetParam;

  rootCertificateDialog: CustomDialogController = new CustomDialogController({
    alignment: DialogAlignment.Center,
    cancel: () => {
      this.toggleStatus = false;
    },
    builder: AlertDialog({
      primaryTitle: $r('app.string.root_certificate'),
      content: $r('app.string.root_certificate_message'),
      primaryButton: {
        value: $r('app.string.root_certificate_cancel'),
        buttonStyle: ButtonStyleMode.TEXTUAL,
        action: () => {
          this.toggleStatus = false;
          this.showUserCaPresenter.updateUserTrustedCertificateList();
        }
      },
      secondaryButton: {
        value: $r('app.string.root_certificate_continue'),
        buttonStyle: ButtonStyleMode.TEXTUAL,
        action: () => {
          this.showUserCaPresenter.setUserCertificateStatus(this.showUserCaPresenter.certInfo.uri, true)
            .then(result => {
              if (result) {
                this.showUserCaPresenter.updateUserTrustedCertificateList();
              } else {
                this.toggleStatus = false;
              }
          });
        }
      }
    })
  })

  deleteCertWarnDialog: CustomDialogController = new CustomDialogController({
    builder: AlertDialog({
      primaryTitle: $r('app.string.CustomDialogExampleUser_warning_Button_title_text'),
      content: $r('app.string.CustomDialogExampleUser_warning_Button_message_text'),
      primaryButton: {
        value: $r('app.string.deleteAllCredCancel'),
        buttonStyle: ButtonStyleMode.TEXTUAL,
        action: () => {
        }
      },
      secondaryButton: {
        value: $r('app.string.deleteAllCredDelete'),
        buttonStyle: ButtonStyleMode.TEXTUAL,
        action: () => {
          this.showUserCaPresenter.deleteUserCertificate(this.showUserCaPresenter.certInfo.uri, () => {
            this.showUserCaPresenter.updateUserTrustedCertificateList();
          })
          this.stack?.pop();
        },
        role: ButtonRole.ERROR
      }
    })
  })

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.Bottom }) {
        Stack({ alignContent: Alignment.Top }) {
          Column() {
            HeadComponent({ headName: $r('app.string.CustomDialogExample_firText'), isStartBySheet: true, onBackClicked: () => {
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

          Stack({ alignContent: Alignment.TopEnd }) {
            Scroll() {
              this.buildContent()
            }
            .padding({
              left: 16, right: 16
            })
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
          Button($r('app.string.CustomDialogExampleUser_warning_Button_title_text'))
            .onClick(() => {
              this.deleteCertWarnDialog.open();
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
    .height(this.sheetParam?.lastSheetPage === NavEntryKey.CA_USER_DETAIL_ENTRY ?
      WidthPercent.WH_AUTO : this.sheetParam?.sheetMinHeight)
    .backgroundColor($r('sys.color.background_secondary'))
    .onReady((ctx: NavDestinationContext) => {
      this.stack = ctx.pathStack;
      try {
        this.showUserCaPresenter = (ctx.pathInfo.param as CaUserDetailParam).showUserCaPresenter;
        this.toggleStatus = this.showUserCaPresenter.certInfo.status;
      } catch (err) {
        let error = err as BusinessError;
        console.error(TAG + 'Get presenter failed: ' + error?.code + ', message: ' + error?.message);
      }
    })
  }

  @Builder
  private buildContent() {
    Column() {
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Column() {
          Text(this.showUserCaPresenter.certInfo.certAlias)
            .fontSize($r('sys.float.ohos_id_text_size_body1'))
            .fontColor($r('sys.color.ohos_id_color_text_primary'))
            .fontWeight(FontWeight.Medium)
        }.alignItems(HorizontalAlign.Start);

        Toggle({ type: ToggleType.Switch, isOn: $$this.toggleStatus })
          .margin({
            left: $r('app.float.wh_value_5')
          })
          .flexShrink(0)
          .onChange((isOn: boolean) => {
            if (isOn) {
              this.rootCertificateDialog.open();
            } else {
              this.showUserCaPresenter.setUserCertificateStatus(this.showUserCaPresenter.certInfo.uri, false);
            }
          })
      }.margin({ top: 8 })

      Text($r('app.string.CustomDialogExample_firListItem_text'))
        .fontSize($r('sys.float.ohos_id_text_size_body1'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(FontWeight.Medium)
        .margin({
          top: $r('app.float.wh_value_24')
        })

      DialogSubjectComponent({ map: this.showUserCaPresenter.certInfo.subjectNameMap })

      Text($r('app.string.CustomDialogExample_secListItem_text'))
        .fontSize($r('sys.float.ohos_id_text_size_body1'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(FontWeight.Medium)
        .margin({
          top: $r('app.float.wh_value_24')
        })

      DialogIssuerComponent({ map: this.showUserCaPresenter.certInfo.issuerNameMap })

      Text($r('app.string.CustomDialogExample_thdListItem_text'))
        .fontSize($r('sys.float.ohos_id_text_size_body1'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(FontWeight.Medium)
        .margin({
          top: $r('app.float.wh_value_24')
        })

      DialogDateComponent({ map: this.showUserCaPresenter.certInfo.dateMap })

      Text($r('app.string.CustomDialogExample_fouListItem_text'))
        .fontSize($r('sys.float.ohos_id_text_size_body1'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(FontWeight.Medium)
        .margin({
          top: $r('app.float.wh_value_24')
        })

      DialogFingerPrintComponent({
        fingerprintSha256: this.showUserCaPresenter.certInfo.fingerprintSha256
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