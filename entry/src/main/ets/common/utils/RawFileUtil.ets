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

import util from '@ohos.util';
import resmgr from '@ohos.resourceManager';
import Logger from './Logger';

const TAG: string = 'RawFileUtil';
const UNICODE: string = 'utf-8';

/**
 * RawFile工具类
 */
export class RawFileUtil {
  /**
   * 获取指定的JSON文件的对象
   *
   * @param resourceManager 资源管理器
   * @param fileName 文件名
   * @returns string格式的文件内容
   */
  public static async getStringByFile(resourceManager: resmgr.ResourceManager, fileName: string): Promise<string> {
    Logger.info(TAG, `getFileContent. fileName: ${fileName}`);
    if (resourceManager === null || fileName === null) {
      Logger.error(TAG, `getFileContent failed.resourceManager or fileName is null.fileName:${fileName}`);
      return '';
    }
    try {
      let value: Uint8Array = await resourceManager.getRawFileContent(fileName);
      let content = util.TextDecoder.create(UNICODE).decodeWithStream(value);
      return content;
    } catch (jsonError) {
      Logger.error(TAG, `JSON parse error: ${jsonError?.code} ${jsonError?.message}`);
    }
    return '';
  }

  /**
   * 获取指定的JSON文件的对象
   *
   * @param context 上下文
   * @param fileName 文件名
   * @return string格式的文件内容
   */
  public static async getRawFileByContext(context: Context, fileName: string): Promise<string> {
    Logger.info(TAG, `getFileContent. fileName: ${fileName}`);
    if (context === null || fileName === null) {
      Logger.error(TAG, `getFileContent failed.resourceManager or fileName is null.fileName:${fileName}`);
      return '';
    }
    try {
      let value: Uint8Array = await context.resourceManager.getRawFileContent(fileName);
      let content = util.TextDecoder.create('utf-8').decodeWithStream(value);
      return content;
    } catch (jsonError) {
      Logger.error(TAG, `JSON parse error: ${jsonError?.code} ${jsonError?.message}`);
    }
    return '';
  }
}