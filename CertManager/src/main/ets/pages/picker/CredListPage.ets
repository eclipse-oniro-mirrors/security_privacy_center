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

import { NavEntryKey } from '../../common/NavEntryKey';
import { WidthPercent } from '../../common/util/ConfigData';
import { evidenceList } from '../cerEvidenceFa';
import { SheetParam } from '../../common/util/SheetParam';

@Component
export struct CredListPage {
  private stack?: NavPathStack;

  @Prop sheetParam: SheetParam;

  build() {
    NavDestination() {
      Column() {
        evidenceList({
          isStartBySheet: true,
          sheetParam: this.sheetParam,
          selected: (path, param) => {
            if (path === NavEntryKey.POP) {
              this.stack?.pop();
            } else {
              this.stack?.pushPath(new NavPathInfo(path, param));
            }
          }
        })
      }
    }
    .hideTitleBar(true)
    .width(WidthPercent.WH_100_100)
    .height(this.sheetParam?.lastSheetPage === NavEntryKey.CREDENTIAL_LIST_ENTRY ?
      WidthPercent.WH_AUTO : this.sheetParam?.sheetMinHeight)
    .backgroundColor($r('sys.color.background_secondary'))
    .onReady((ctx: NavDestinationContext) => {
      this.stack = ctx.pathStack;
    })
  }
}