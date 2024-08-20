import { http } from '@kit.NetworkKit'

export class RequestInfo {
  method: http.RequestMethod = http.RequestMethod.GET;
  url: string;
  params: KV[];
  headers: KV[];
  bodyType: number = 0;
  fromData: KV[];
  fromUrlEncoded: KV[];
  rawJsonStr: string;
}

export interface KV {
  key: string,
  value: string,
  isOn: boolean,
}