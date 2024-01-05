using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.Sys
{
    /// <summary>
    /// 数据字典主表
    /// </summary>
    public class Sys_dict_type
    {
        //字典主键
        public int dict_id {  get; set; }
        //字典排序
        public string dict_name {  get; set; }
        //字典标签
        public string dict_label { get; set; }
        //字典键值
        public string dict_value {  get; set; }
        //操作人
        public string create_by {  get; set; }
        //操作时间
        public DateTime create_time { get; set; }
        //更新者
        public string update_by { get; set;}
        //更新时间
        public DateTime? update_time { get; set;}
        //备注
        public string remark { get; set; }

        public string is_del { get; set; }

        public string status { get; set; }
    }
}
