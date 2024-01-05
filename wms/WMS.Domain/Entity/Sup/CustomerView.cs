﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.Sup
{
    public class CustomerView
    {
        [Key]
        public int customer_id {  get; set; }//客户id
        public int finance_id {  get; set; }//银行id
        public string cust_code {  get; set; }//客户编号
        public string cust_name { get; set; }//客户名称
        public string line_type {  get; set; }//所属行业
        public string cust_from {  get; set; }//客户来源
        public string link_man {  get; set; }//联系人
        public string link_tel {  get; set; }//联系电话
        public string e_mail {  get; set; }//邮箱
        public string head_of_Sales {  get; set; }//销售负责人
        public string inbill_state {  get; set; }//状态
        public string cust_adr {  get; set; }//客户地址
        public string finance_name {  get; set; }//账户名称
        public string tax_no {  get; set; }//纳税人识别号
        public string bank_no {  get; set; }//银行账户
        public string open_bank {  get; set; }//开户银行
        public string open_adr {  get; set; }//开户行地址
        public string operatoro {  get; set; }//操作人
        public string opetime {  get; set; }//操作时间
        public string is_del {  get; set; }//逻辑删除
        public string fis_del {  get; set; }//银行逻辑删除
        public string remark { get; set; }//备注
    }
}