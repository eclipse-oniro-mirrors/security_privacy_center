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
import { NavEntryKey } from '../../common/NavEntryKey';
import { WidthPercent } from '../../common/util/ConfigData';
import CmShowSysCaPresenter from '../../presenter/CmShowSysCaPresenter';
import { SheetParam } from '../../common/util/SheetParam';

@Component
export struct DialogSubjectComponent {
  private map?: Map<string, string>;
  private subjectNameCN: string = '';
  private subjectNameO: string = '';
  private subjectNameOU: string = '';
  private serial: string = '';

  aboutToAppear() {
    if (this.map != null) {
      let subjectNameCN = this.map.get('常用名称:');
      if (subjectNameCN !== undefined) {
        this.subjectNameCN = subjectNameCN;
      }

      let subjectNameO = this.map.get('组织:');
      if (subjectNameO !== undefined) {
        this.subjectNameO = subjectNameO;
      }

      let subjectNameOU = this.map.get('组织单位:');
      if (subjectNameOU !== undefined) {
        this.subjectNameOU = subjectNameOU;
      }

      let serial = this.map.get('序列号:');
      if (serial !== undefined) {
        this.serial = serial;
      }
    }
  }

  build() {
    Column() {
      Text($r('app.string.DialogSubjectComponent_firText'))
        .fontSize($r('sys.float.ohos_id_text_size_body2'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(FontWeight.Regular)
        .margin({
          top: $r('app.float.sys_elements_margin_vertical_l')
        })
      Text(this.subjectNameCN)
        .fontSize($r('sys.float.ohos_id_text_size_body2'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(FontWeight.Regular)
      Text($r('app.string.DialogSubjectComponent_secText'))
        .fontSize($r('sys.float.ohos_id_text_size_body2'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(FontWeight.Regular)
        .margin({
          top: $r('app.float.sys_elements_margin_vertical_m')
        })
      Text(this.subjectNameO)
        .fontSize($r('sys.float.ohos_id_text_size_body2'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(FontWeight.Regular)
      Text($r('app.string.DialogSubjectComponent_thdText'))
        .fontSize($r('sys.float.ohos_id_text_size_body2'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(FontWeight.Regular)
        .margin({
          top: $r('app.float.sys_elements_margin_vertical_m')
        })
      Text(this.subjectNameOU)
        .fontSize($r('sys.float.ohos_id_text_size_body2'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(FontWeight.Regular)
      Text($r('app.string.DialogSubjectComponent_fouText'))
        .fontSize($r('sys.float.ohos_id_text_size_body2'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(FontWeight.Regular)
        .margin({
          top: $r('app.float.sys_elements_margin_vertical_m')
        })
      Text(this.serial)
        .fontSize($r('sys.float.ohos_id_text_size_body2'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(FontWeight.Regular)
    }.alignItems(HorizontalAlign.Start);
  }
}

@Component
export struct DialogIssuerComponent {
  private map?: Map<string, string>;
  private issuerNameCN: string = '';
  private issuerNameO: string = '';
  private issuerNameOU: string = '';

  aboutToAppear() {
    if (this.map != null) {
      let issuerNameCN = this.map.get('常用名称:');
      if (issuerNameCN !== undefined) {
        this.issuerNameCN = issuerNameCN;
      }

      let issuerNameO = this.map.get('组织:');
      if (issuerNameO !== undefined) {
        this.issuerNameO = issuerNameO;
      }

      let issuerNameOU = this.map.get('组织单位:');
      if (issuerNameOU !== undefined) {
        this.issuerNameOU = issuerNameOU;
      }
    }
  }

  build() {
    Column() {
      Text($r('app.string.DialogSubjectComponent_firText'))
        .fontSize($r('sys.float.ohos_id_text_size_body2'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(FontWeight.Regular)
        .margin({
          top: $r('app.float.sys_elements_margin_vertical_l')
        })
      Text(this.issuerNameCN)
        .fontSize($r('sys.float.ohos_id_text_size_body2'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(FontWeight.Regular)
      Text($r('app.string.DialogSubjectComponent_secText'))
        .fontSize($r('sys.float.ohos_id_text_size_body2'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(FontWeight.Regular)
        .margin({
          top: $r('app.float.sys_elements_margin_vertical_m')
        })
      Text(this.issuerNameO)
        .fontSize($r('sys.float.ohos_id_text_size_body2'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(FontWeight.Regular)
      Text($r('app.string.DialogSubjectComponent_thdText'))
        .fontSize($r('sys.float.ohos_id_text_size_body2'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(FontWeight.Regular)
        .margin({
          top: $r('app.float.sys_elements_margin_vertical_m')
        })
      Text(this.issuerNameOU)
        .fontSize($r('sys.float.ohos_id_text_size_body2'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(FontWeight.Regular)
    }.alignItems(HorizontalAlign.Start);
  }
}

@Component
export struct DialogDateComponent {
  private map?: Map<string, string>;
  private notBefore: string = '';
  private notAfter: string = '';

  aboutToAppear() {
    if (this.map != null) {
      let notBefore = this.map.get('颁发时间:');
      if (notBefore != undefined) {
        this.notBefore = notBefore;
      }

      let notAfter = this.map.get('有效期至:');
      if (notAfter != undefined) {
        this.notAfter = notAfter;
      }
    }
  }

  build() {
    Column() {
      Text($r('app.string.DialogSubjectComponent_fifText'))
        .fontSize($r('sys.float.ohos_id_text_size_body2'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(FontWeight.Regular)
        .margin({
          top: $r('app.float.sys_elements_margin_vertical_l')
        })
      Text(this.notBefore)
        .fontSize($r('sys.float.ohos_id_text_size_body2'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(FontWeight.Regular)
      Text($r('app.string.DialogSubjectComponent_sixText'))
        .fontSize($r('sys.float.ohos_id_text_size_body2'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(FontWeight.Regular)
        .margin({
          top: $r('app.float.sys_elements_margin_vertical_m')
        })
      Text(this.notAfter)
        .fontSize($r('sys.float.ohos_id_text_size_body2'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(FontWeight.Regular)
    }.alignItems(HorizontalAlign.Start);
  }
}

@Component
export struct DialogFingerPrintComponent {
  private fingerprintSha256: string = '';

  build() {
    Column() {
      Text($r('app.string.CustomDialogExample_FingerPrint_text'))
        .fontSize($r('sys.float.ohos_id_text_size_body2'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(FontWeight.Regular)
        .margin({
          top: $r('app.float.sys_elements_margin_vertical_l')
        })
      Text(this.fingerprintSha256)
        .fontSize($r('sys.float.ohos_id_text_size_body2'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(FontWeight.Regular)
        .margin({
          right: $r('app.float.wh_value_24')
        })
    }.alignItems(HorizontalAlign.Start);
  }
}

@Component
export struct CaSystemDetailPage {
  @State mShowSysCaPresenter: CmShowSysCaPresenter = CmShowSysCaPresenter.getInstance();

  private stack?: NavPathStack;

  @State headRectHeight: number = 64;
  @State headRectHeightReal: number = 0;
  @Prop sheetParam: SheetParam;
  private scroller: Scroller = new Scroller();
  @State scrollerHeight: number = 0;

  build() {
    NavDestination() {
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
          Scroll(this.scroller) {
            this.buildContent()
          }
          .padding({
            left: 16, right: 16,
            bottom: $r('app.float.wh_value_24')
          })
          .align(Alignment.Top)
          .scrollable(ScrollDirection.Vertical)
          .edgeEffect(EdgeEffect.Spring)
          .scrollBar(BarState.Off)
          .width(WidthPercent.WH_100_100)
          .height(WidthPercent.WH_AUTO)
          .constraintSize({
            minHeight: this.getScrollMinHeight()
          }).onAreaChange((oldArea, newArea) => {
            this.scrollerHeight = newArea.height as number;
          })

          Column() {
            ScrollBar({
              scroller: this.scroller,
              direction: ScrollBarDirection.Vertical,
              state: BarState.Auto
            }).margin({
              bottom: $r('app.float.wh_value_24')
            })
          }.height(this.scrollerHeight)
        }.padding({
          top: this.headRectHeight
        })
      }
    }
    .hideTitleBar(true)
    .width(WidthPercent.WH_100_100)
    .height(this.sheetParam?.lastSheetPage === NavEntryKey.CA_SYSTEM_DETAIL_ENTRY ?
      WidthPercent.WH_AUTO : this.sheetParam?.sheetMinHeight)
    .backgroundColor($r('sys.color.background_secondary'))
    .onReady((ctx: NavDestinationContext) => {
      this.stack = ctx.pathStack;
    })
  }

  getScrollMinHeight() {
    if (this.sheetParam === undefined || this.headRectHeightReal === 0 ||
      this.sheetParam.sheetMinHeight < this.headRectHeightReal) {
      return 0;
    }
    return this.sheetParam.sheetMinHeight - this.headRectHeightReal;
  }

  @Builder
  private buildContent() {
    Column() {
      Text(this.mShowSysCaPresenter.certInfo.certAlias)
        .fontSize($r('sys.float.ohos_id_text_size_body1'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(FontWeight.Medium)
        .margin({
          top: $r('app.float.wh_value_8'),
          bottom: $r('app.float.wh_value_24')
        })
        .alignSelf(ItemAlign.Start)

      Text($r('app.string.CustomDialogExample_firListItem_text'))
        .fontSize($r('sys.float.ohos_id_text_size_body1'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(FontWeight.Medium)

      DialogSubjectComponent({ map: this.mShowSysCaPresenter.certInfo.subjectNameMap })

      Text($r('app.string.CustomDialogExample_secListItem_text'))
        .fontSize($r('sys.float.ohos_id_text_size_body1'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(FontWeight.Medium)
        .margin({
          top: $r('app.float.wh_value_24')
        })

      DialogIssuerComponent({ map: this.mShowSysCaPresenter.certInfo.issuerNameMap })

      Text($r('app.string.CustomDialogExample_thdListItem_text'))
        .fontSize($r('sys.float.ohos_id_text_size_body1'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(FontWeight.Medium)
        .margin({
          top: $r('app.float.wh_value_24')
        })

      DialogDateComponent({ map: this.mShowSysCaPresenter.certInfo.dateMap })

      Text($r('app.string.CustomDialogExample_fouListItem_text'))
        .fontSize($r('sys.float.ohos_id_text_size_body1'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(FontWeight.Medium)
        .margin({
          top: $r('app.float.wh_value_24')
        })

      DialogFingerPrintComponent({ fingerprintSha256: this.mShowSysCaPresenter.certInfo.fingerprintSha256 })
    }
    .alignItems(HorizontalAlign.Start)
    .width(WidthPercent.WH_100_100)
  }
}