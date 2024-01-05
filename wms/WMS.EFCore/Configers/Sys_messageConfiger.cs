using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity.Sys;

namespace WMS.EFCore.Configers
{
    /// <summary>
    /// 系统消息
    /// </summary>
    internal class Sys_messageConfiger : IEntityTypeConfiguration<Sys_message>
    {
        public void Configure(EntityTypeBuilder<Sys_message> builder)
        {
            builder.ToTable(nameof(Sys_message));
            builder.HasKey(e => e.msg_id);
            builder.Property(e => e.msg_content).HasMaxLength(500).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.msg_type).HasMaxLength(10).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.msg_state).HasColumnType("char(1)").IsRequired(false);
            builder.Property(e => e.send_man).HasMaxLength(64).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.send_time).HasColumnType("datetime").IsRequired();
            builder.Property(e => e.rcv_man).HasMaxLength(64).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.rcv_time).HasColumnType("datetime").IsRequired();
            builder.Property(e => e.is_read).HasColumnType("char(1)").IsRequired(false);
            builder.Property(e => e.deal_url).HasMaxLength(100).IsUnicode(false).IsRequired(false);
        }
    }
}
