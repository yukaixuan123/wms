using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.Sys
{
    /// <summary>
    /// 系统消息
    /// </summary>
    public class Sys_message
    {
        //消息序号
        public int msg_id { get; set; }
        //消息内容
        public string msg_content { get; set; }
        //消息类型
        public string msg_type { get; set;}
        //消息状态
        public string msg_state { get; set; }
        //发送人
        public string send_man {  get; set; }
        //发送时间
        public DateTime send_time { get; set; }
        //接收人
        public string rcv_man { get; set; }
        //接收时间
        public DateTime rcv_time { get; set; }
        //是否阅读
        public string is_read { get; set; }
        //处理链接
        public string deal_url { get; set; }
    }
}
