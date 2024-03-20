/**
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

//检查的状态参数。用于设置应用权限组检查状态
// 这是应用权限组的状态部分，仅包含选中的状态和权限组标志
export class CheckedStateParameter {
  //   权限组检查状态
  //   有效的权限状态：ALLOW,ALLOW_ALL_THE_TIME,ALLOW_ONLY_WHILE_IN_USE,ASK_EACH_TIME,DENY,
  //                MEDIA_ONLY,ALLOW_MANAGEMENT_OF_ALL_FILES
  checkedState: string;
  //   附加标志
  flagMask: number;
  //   附加标志
  flagValue: number;

  constructor(checkedState: string, flagMask: number, flagValue: number) {
    this.checkedState = checkedState;
    this.flagMask = flagMask;
    this.flagValue = flagValue;
  }
}
