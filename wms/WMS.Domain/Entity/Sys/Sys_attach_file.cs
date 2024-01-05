using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.Sys
{
    /// <summary>
    /// 公共附件表
    /// </summary>
    public class Sys_attach_file
    {
        //id
        public int saf_id {  get; set; }
        //单据编码
        public string bill_code {  get; set; }
        //附件id
        public int file_id {  get; set; }
        //附件类型
        public string file_type { get; set; }
        //附件url
        public string file_url { get; set; }
        //操作人
        public string create_by { get; set; }
        //操作时间
        public DateTime create_time { get; set;}
    }
}
