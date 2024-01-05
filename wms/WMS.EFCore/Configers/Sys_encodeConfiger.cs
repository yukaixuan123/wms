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
    /// 编码规则表
    /// </summary>
    internal class Sys_encodeConfiger : IEntityTypeConfiguration<Sys_encode>
    {
        public void Configure(EntityTypeBuilder<Sys_encode> builder)
        {
            builder.ToTable(nameof(Sys_encode));
            builder.HasKey(e => e.en_code);
            builder.Property(e => e.en_form).HasMaxLength(64).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.en_prefix).HasMaxLength(30).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.en_time).HasMaxLength(50).IsUnicode(false).IsRequired(false);
            builder.HasKey(e => e.en_num);
            builder.HasKey(e => e.en_step);
            builder.Property(e => e.en_rules).HasMaxLength(80).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.create_by).HasMaxLength(64).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.create_time).HasColumnType("datetime").IsRequired();
            builder.Property(e => e.is_del).HasColumnType("char(1)").IsRequired(false);
        }
    }
}
