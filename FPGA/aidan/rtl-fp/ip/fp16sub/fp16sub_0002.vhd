-- ------------------------------------------------------------------------- 
-- High Level Design Compiler for Intel(R) FPGAs Version 23.1std (Release Build #993)
-- Quartus Prime development tool and MATLAB/Simulink Interface
-- 
-- Legal Notice: Copyright 2024 Intel Corporation.  All rights reserved.
-- Your use of  Intel Corporation's design tools,  logic functions and other
-- software and  tools, and its AMPP partner logic functions, and any output
-- files any  of the foregoing (including  device programming  or simulation
-- files), and  any associated  documentation  or information  are expressly
-- subject  to the terms and  conditions of the  Intel FPGA Software License
-- Agreement, Intel MegaCore Function License Agreement, or other applicable
-- license agreement,  including,  without limitation,  that your use is for
-- the  sole  purpose of  programming  logic devices  manufactured by  Intel
-- and  sold by Intel  or its authorized  distributors. Please refer  to the
-- applicable agreement for further details.
-- ---------------------------------------------------------------------------

-- VHDL created from fp16sub_0002
-- VHDL created on Sat Nov 16 14:15:53 2024


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.MATH_REAL.all;
use std.TextIO.all;
use work.dspba_library_package.all;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;
LIBRARY altera_lnsim;
USE altera_lnsim.altera_lnsim_components.altera_syncram;
LIBRARY lpm;
USE lpm.lpm_components.all;

entity fp16sub_0002 is
    port (
        a : in std_logic_vector(15 downto 0);  -- float16_m10
        b : in std_logic_vector(15 downto 0);  -- float16_m10
        q : out std_logic_vector(15 downto 0);  -- float16_m10
        clk : in std_logic;
        areset : in std_logic
    );
end fp16sub_0002;

architecture normal of fp16sub_0002 is

    attribute altera_attribute : string;
    attribute altera_attribute of normal : architecture is "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF; -name PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION ON; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 10037; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 15400; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 12020; -name MESSAGE_DISABLE 12030; -name MESSAGE_DISABLE 12010; -name MESSAGE_DISABLE 12110; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 13410; -name MESSAGE_DISABLE 113007";
    
    signal GND_q : STD_LOGIC_VECTOR (0 downto 0);
    signal VCC_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expFracX_uid6_fpSubTest_b : STD_LOGIC_VECTOR (14 downto 0);
    signal expFracY_uid7_fpSubTest_b : STD_LOGIC_VECTOR (14 downto 0);
    signal xGTEy_uid8_fpSubTest_a : STD_LOGIC_VECTOR (16 downto 0);
    signal xGTEy_uid8_fpSubTest_b : STD_LOGIC_VECTOR (16 downto 0);
    signal xGTEy_uid8_fpSubTest_o : STD_LOGIC_VECTOR (16 downto 0);
    signal xGTEy_uid8_fpSubTest_n : STD_LOGIC_VECTOR (0 downto 0);
    signal fracY_uid9_fpSubTest_b : STD_LOGIC_VECTOR (9 downto 0);
    signal expY_uid10_fpSubTest_b : STD_LOGIC_VECTOR (4 downto 0);
    signal sigY_uid11_fpSubTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal invSigY_uid12_fpSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal ypn_uid13_fpSubTest_q : STD_LOGIC_VECTOR (15 downto 0);
    signal aSig_uid17_fpSubTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal aSig_uid17_fpSubTest_q : STD_LOGIC_VECTOR (15 downto 0);
    signal bSig_uid18_fpSubTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal bSig_uid18_fpSubTest_q : STD_LOGIC_VECTOR (15 downto 0);
    signal cstAllOWE_uid19_fpSubTest_q : STD_LOGIC_VECTOR (4 downto 0);
    signal cstZeroWF_uid20_fpSubTest_q : STD_LOGIC_VECTOR (9 downto 0);
    signal cstAllZWE_uid21_fpSubTest_q : STD_LOGIC_VECTOR (4 downto 0);
    signal exp_aSig_uid22_fpSubTest_in : STD_LOGIC_VECTOR (14 downto 0);
    signal exp_aSig_uid22_fpSubTest_b : STD_LOGIC_VECTOR (4 downto 0);
    signal frac_aSig_uid23_fpSubTest_in : STD_LOGIC_VECTOR (9 downto 0);
    signal frac_aSig_uid23_fpSubTest_b : STD_LOGIC_VECTOR (9 downto 0);
    signal excZ_aSig_uid17_uid24_fpSubTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal excZ_aSig_uid17_uid24_fpSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expXIsMax_uid25_fpSubTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal expXIsMax_uid25_fpSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid26_fpSubTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid26_fpSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsNotZero_uid27_fpSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excI_aSig_uid28_fpSubTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal excI_aSig_uid28_fpSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excN_aSig_uid29_fpSubTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal excN_aSig_uid29_fpSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invExpXIsMax_uid30_fpSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal InvExpXIsZero_uid31_fpSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excR_aSig_uid32_fpSubTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal excR_aSig_uid32_fpSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal exp_bSig_uid36_fpSubTest_in : STD_LOGIC_VECTOR (14 downto 0);
    signal exp_bSig_uid36_fpSubTest_b : STD_LOGIC_VECTOR (4 downto 0);
    signal frac_bSig_uid37_fpSubTest_in : STD_LOGIC_VECTOR (9 downto 0);
    signal frac_bSig_uid37_fpSubTest_b : STD_LOGIC_VECTOR (9 downto 0);
    signal excZ_bSig_uid18_uid38_fpSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expXIsMax_uid39_fpSubTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal expXIsMax_uid39_fpSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid40_fpSubTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid40_fpSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsNotZero_uid41_fpSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excI_bSig_uid42_fpSubTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal excI_bSig_uid42_fpSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excN_bSig_uid43_fpSubTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal excN_bSig_uid43_fpSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invExpXIsMax_uid44_fpSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal InvExpXIsZero_uid45_fpSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excR_bSig_uid46_fpSubTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal excR_bSig_uid46_fpSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal sigA_uid51_fpSubTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal sigB_uid52_fpSubTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal effSub_uid53_fpSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracBz_uid57_fpSubTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal fracBz_uid57_fpSubTest_q : STD_LOGIC_VECTOR (9 downto 0);
    signal oFracB_uid60_fpSubTest_q : STD_LOGIC_VECTOR (10 downto 0);
    signal expAmExpB_uid61_fpSubTest_a : STD_LOGIC_VECTOR (5 downto 0);
    signal expAmExpB_uid61_fpSubTest_b : STD_LOGIC_VECTOR (5 downto 0);
    signal expAmExpB_uid61_fpSubTest_o : STD_LOGIC_VECTOR (5 downto 0);
    signal expAmExpB_uid61_fpSubTest_q : STD_LOGIC_VECTOR (5 downto 0);
    signal oFracA_uid65_fpSubTest_q : STD_LOGIC_VECTOR (10 downto 0);
    signal oFracAE_uid66_fpSubTest_q : STD_LOGIC_VECTOR (13 downto 0);
    signal oFracBR_uid68_fpSubTest_q : STD_LOGIC_VECTOR (13 downto 0);
    signal oFracBREX_uid69_fpSubTest_b : STD_LOGIC_VECTOR (13 downto 0);
    signal oFracBREX_uid69_fpSubTest_qi : STD_LOGIC_VECTOR (13 downto 0);
    signal oFracBREX_uid69_fpSubTest_q : STD_LOGIC_VECTOR (13 downto 0);
    signal oFracBREXC2_uid70_fpSubTest_a : STD_LOGIC_VECTOR (14 downto 0);
    signal oFracBREXC2_uid70_fpSubTest_b : STD_LOGIC_VECTOR (14 downto 0);
    signal oFracBREXC2_uid70_fpSubTest_o : STD_LOGIC_VECTOR (14 downto 0);
    signal oFracBREXC2_uid70_fpSubTest_q : STD_LOGIC_VECTOR (14 downto 0);
    signal oFracBREXC2_uid71_fpSubTest_in : STD_LOGIC_VECTOR (13 downto 0);
    signal oFracBREXC2_uid71_fpSubTest_b : STD_LOGIC_VECTOR (13 downto 0);
    signal fracAddResult_uid73_fpSubTest_a : STD_LOGIC_VECTOR (14 downto 0);
    signal fracAddResult_uid73_fpSubTest_b : STD_LOGIC_VECTOR (14 downto 0);
    signal fracAddResult_uid73_fpSubTest_o : STD_LOGIC_VECTOR (14 downto 0);
    signal fracAddResult_uid73_fpSubTest_q : STD_LOGIC_VECTOR (14 downto 0);
    signal fracAddResultNoSignExt_uid74_fpSubTest_in : STD_LOGIC_VECTOR (13 downto 0);
    signal fracAddResultNoSignExt_uid74_fpSubTest_b : STD_LOGIC_VECTOR (13 downto 0);
    signal cAmA_uid77_fpSubTest_q : STD_LOGIC_VECTOR (3 downto 0);
    signal aMinusA_uid78_fpSubTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal aMinusA_uid78_fpSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expInc_uid79_fpSubTest_a : STD_LOGIC_VECTOR (5 downto 0);
    signal expInc_uid79_fpSubTest_b : STD_LOGIC_VECTOR (5 downto 0);
    signal expInc_uid79_fpSubTest_o : STD_LOGIC_VECTOR (5 downto 0);
    signal expInc_uid79_fpSubTest_q : STD_LOGIC_VECTOR (5 downto 0);
    signal expPostNorm_uid80_fpSubTest_a : STD_LOGIC_VECTOR (6 downto 0);
    signal expPostNorm_uid80_fpSubTest_b : STD_LOGIC_VECTOR (6 downto 0);
    signal expPostNorm_uid80_fpSubTest_o : STD_LOGIC_VECTOR (6 downto 0);
    signal expPostNorm_uid80_fpSubTest_q : STD_LOGIC_VECTOR (6 downto 0);
    signal fracPostNormRndRange_uid81_fpSubTest_in : STD_LOGIC_VECTOR (12 downto 0);
    signal fracPostNormRndRange_uid81_fpSubTest_b : STD_LOGIC_VECTOR (10 downto 0);
    signal expFracR_uid82_fpSubTest_q : STD_LOGIC_VECTOR (17 downto 0);
    signal wEP2AllOwE_uid83_fpSubTest_q : STD_LOGIC_VECTOR (6 downto 0);
    signal rndExp_uid84_fpSubTest_b : STD_LOGIC_VECTOR (6 downto 0);
    signal rOvf_uid85_fpSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal rUdf_uid86_fpSubTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal fracRPreExc_uid87_fpSubTest_in : STD_LOGIC_VECTOR (10 downto 0);
    signal fracRPreExc_uid87_fpSubTest_b : STD_LOGIC_VECTOR (9 downto 0);
    signal expRPreExc_uid88_fpSubTest_in : STD_LOGIC_VECTOR (15 downto 0);
    signal expRPreExc_uid88_fpSubTest_b : STD_LOGIC_VECTOR (4 downto 0);
    signal regInputs_uid89_fpSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRZeroVInC_uid90_fpSubTest_q : STD_LOGIC_VECTOR (4 downto 0);
    signal excRZero_uid91_fpSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal rInfOvf_uid92_fpSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRInfVInC_uid93_fpSubTest_q : STD_LOGIC_VECTOR (5 downto 0);
    signal excRInf_uid94_fpSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRNaN2_uid95_fpSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excAIBISub_uid96_fpSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRNaN_uid97_fpSubTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal excRNaN_uid97_fpSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal concExc_uid98_fpSubTest_q : STD_LOGIC_VECTOR (2 downto 0);
    signal excREnc_uid99_fpSubTest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal invAMinusA_uid100_fpSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal signRReg_uid101_fpSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal sigBBInf_uid102_fpSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal sigAAInf_uid103_fpSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal signRInf_uid104_fpSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excAZBZSigASigB_uid105_fpSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excBZARSigA_uid106_fpSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal signRZero_uid107_fpSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal signRInfRZRReg_uid108_fpSubTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal signRInfRZRReg_uid108_fpSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invExcRNaN_uid109_fpSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal signRPostExc_uid110_fpSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal oneFracRPostExc2_uid111_fpSubTest_q : STD_LOGIC_VECTOR (9 downto 0);
    signal fracRPostExc_uid114_fpSubTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal fracRPostExc_uid114_fpSubTest_q : STD_LOGIC_VECTOR (9 downto 0);
    signal expRPostExc_uid118_fpSubTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal expRPostExc_uid118_fpSubTest_q : STD_LOGIC_VECTOR (4 downto 0);
    signal R_uid119_fpSubTest_q : STD_LOGIC_VECTOR (15 downto 0);
    signal zs_uid121_lzCountVal_uid75_fpSubTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal rVStage_uid122_lzCountVal_uid75_fpSubTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal vCount_uid123_lzCountVal_uid75_fpSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal mO_uid124_lzCountVal_uid75_fpSubTest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal vStage_uid125_lzCountVal_uid75_fpSubTest_in : STD_LOGIC_VECTOR (5 downto 0);
    signal vStage_uid125_lzCountVal_uid75_fpSubTest_b : STD_LOGIC_VECTOR (5 downto 0);
    signal cStage_uid126_lzCountVal_uid75_fpSubTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal vStagei_uid128_lzCountVal_uid75_fpSubTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid128_lzCountVal_uid75_fpSubTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal zs_uid129_lzCountVal_uid75_fpSubTest_q : STD_LOGIC_VECTOR (3 downto 0);
    signal vCount_uid131_lzCountVal_uid75_fpSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid134_lzCountVal_uid75_fpSubTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid134_lzCountVal_uid75_fpSubTest_q : STD_LOGIC_VECTOR (3 downto 0);
    signal zs_uid135_lzCountVal_uid75_fpSubTest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal vCount_uid137_lzCountVal_uid75_fpSubTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal vCount_uid137_lzCountVal_uid75_fpSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid140_lzCountVal_uid75_fpSubTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid140_lzCountVal_uid75_fpSubTest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal rVStage_uid142_lzCountVal_uid75_fpSubTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal vCount_uid143_lzCountVal_uid75_fpSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal r_uid144_lzCountVal_uid75_fpSubTest_q : STD_LOGIC_VECTOR (3 downto 0);
    signal xMSB_uid146_alignmentShifter_uid72_fpSubTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal shiftedOut_uid149_alignmentShifter_uid72_fpSubTest_a : STD_LOGIC_VECTOR (7 downto 0);
    signal shiftedOut_uid149_alignmentShifter_uid72_fpSubTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal shiftedOut_uid149_alignmentShifter_uid72_fpSubTest_o : STD_LOGIC_VECTOR (7 downto 0);
    signal shiftedOut_uid149_alignmentShifter_uid72_fpSubTest_n : STD_LOGIC_VECTOR (0 downto 0);
    signal seMsb_to4_uid150_in : STD_LOGIC_VECTOR (3 downto 0);
    signal seMsb_to4_uid150_b : STD_LOGIC_VECTOR (3 downto 0);
    signal rightShiftStage0Idx1Rng4_uid151_alignmentShifter_uid72_fpSubTest_b : STD_LOGIC_VECTOR (9 downto 0);
    signal rightShiftStage0Idx1_uid152_alignmentShifter_uid72_fpSubTest_q : STD_LOGIC_VECTOR (13 downto 0);
    signal seMsb_to8_uid153_in : STD_LOGIC_VECTOR (7 downto 0);
    signal seMsb_to8_uid153_b : STD_LOGIC_VECTOR (7 downto 0);
    signal rightShiftStage0Idx2Rng8_uid154_alignmentShifter_uid72_fpSubTest_b : STD_LOGIC_VECTOR (5 downto 0);
    signal rightShiftStage0Idx2_uid155_alignmentShifter_uid72_fpSubTest_q : STD_LOGIC_VECTOR (13 downto 0);
    signal seMsb_to12_uid156_in : STD_LOGIC_VECTOR (11 downto 0);
    signal seMsb_to12_uid156_b : STD_LOGIC_VECTOR (11 downto 0);
    signal rightShiftStage0Idx3Rng12_uid157_alignmentShifter_uid72_fpSubTest_b : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStage0Idx3_uid158_alignmentShifter_uid72_fpSubTest_q : STD_LOGIC_VECTOR (13 downto 0);
    signal rightShiftStage0_uid160_alignmentShifter_uid72_fpSubTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStage0_uid160_alignmentShifter_uid72_fpSubTest_q : STD_LOGIC_VECTOR (13 downto 0);
    signal rightShiftStage1Idx1Rng1_uid161_alignmentShifter_uid72_fpSubTest_b : STD_LOGIC_VECTOR (12 downto 0);
    signal rightShiftStage1Idx1_uid162_alignmentShifter_uid72_fpSubTest_q : STD_LOGIC_VECTOR (13 downto 0);
    signal seMsb_to2_uid163_in : STD_LOGIC_VECTOR (1 downto 0);
    signal seMsb_to2_uid163_b : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStage1Idx2Rng2_uid164_alignmentShifter_uid72_fpSubTest_b : STD_LOGIC_VECTOR (11 downto 0);
    signal rightShiftStage1Idx2_uid165_alignmentShifter_uid72_fpSubTest_q : STD_LOGIC_VECTOR (13 downto 0);
    signal seMsb_to3_uid166_in : STD_LOGIC_VECTOR (2 downto 0);
    signal seMsb_to3_uid166_b : STD_LOGIC_VECTOR (2 downto 0);
    signal rightShiftStage1Idx3Rng3_uid167_alignmentShifter_uid72_fpSubTest_b : STD_LOGIC_VECTOR (10 downto 0);
    signal rightShiftStage1Idx3_uid168_alignmentShifter_uid72_fpSubTest_q : STD_LOGIC_VECTOR (13 downto 0);
    signal rightShiftStage1_uid170_alignmentShifter_uid72_fpSubTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStage1_uid170_alignmentShifter_uid72_fpSubTest_q : STD_LOGIC_VECTOR (13 downto 0);
    signal shiftOutConstant_to14_uid171_in : STD_LOGIC_VECTOR (13 downto 0);
    signal shiftOutConstant_to14_uid171_b : STD_LOGIC_VECTOR (13 downto 0);
    signal r_uid173_alignmentShifter_uid72_fpSubTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal r_uid173_alignmentShifter_uid72_fpSubTest_q : STD_LOGIC_VECTOR (13 downto 0);
    signal leftShiftStage0Idx1Rng4_uid178_fracPostNorm_uid76_fpSubTest_in : STD_LOGIC_VECTOR (9 downto 0);
    signal leftShiftStage0Idx1Rng4_uid178_fracPostNorm_uid76_fpSubTest_b : STD_LOGIC_VECTOR (9 downto 0);
    signal leftShiftStage0Idx1_uid179_fracPostNorm_uid76_fpSubTest_q : STD_LOGIC_VECTOR (13 downto 0);
    signal leftShiftStage0Idx2_uid182_fracPostNorm_uid76_fpSubTest_q : STD_LOGIC_VECTOR (13 downto 0);
    signal leftShiftStage0Idx3Pad12_uid183_fracPostNorm_uid76_fpSubTest_q : STD_LOGIC_VECTOR (11 downto 0);
    signal leftShiftStage0Idx3Rng12_uid184_fracPostNorm_uid76_fpSubTest_in : STD_LOGIC_VECTOR (1 downto 0);
    signal leftShiftStage0Idx3Rng12_uid184_fracPostNorm_uid76_fpSubTest_b : STD_LOGIC_VECTOR (1 downto 0);
    signal leftShiftStage0Idx3_uid185_fracPostNorm_uid76_fpSubTest_q : STD_LOGIC_VECTOR (13 downto 0);
    signal leftShiftStage0_uid187_fracPostNorm_uid76_fpSubTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal leftShiftStage0_uid187_fracPostNorm_uid76_fpSubTest_q : STD_LOGIC_VECTOR (13 downto 0);
    signal leftShiftStage1Idx1Rng1_uid189_fracPostNorm_uid76_fpSubTest_in : STD_LOGIC_VECTOR (12 downto 0);
    signal leftShiftStage1Idx1Rng1_uid189_fracPostNorm_uid76_fpSubTest_b : STD_LOGIC_VECTOR (12 downto 0);
    signal leftShiftStage1Idx1_uid190_fracPostNorm_uid76_fpSubTest_q : STD_LOGIC_VECTOR (13 downto 0);
    signal leftShiftStage1Idx2Rng2_uid192_fracPostNorm_uid76_fpSubTest_in : STD_LOGIC_VECTOR (11 downto 0);
    signal leftShiftStage1Idx2Rng2_uid192_fracPostNorm_uid76_fpSubTest_b : STD_LOGIC_VECTOR (11 downto 0);
    signal leftShiftStage1Idx2_uid193_fracPostNorm_uid76_fpSubTest_q : STD_LOGIC_VECTOR (13 downto 0);
    signal leftShiftStage1Idx3Pad3_uid194_fracPostNorm_uid76_fpSubTest_q : STD_LOGIC_VECTOR (2 downto 0);
    signal leftShiftStage1Idx3Rng3_uid195_fracPostNorm_uid76_fpSubTest_in : STD_LOGIC_VECTOR (10 downto 0);
    signal leftShiftStage1Idx3Rng3_uid195_fracPostNorm_uid76_fpSubTest_b : STD_LOGIC_VECTOR (10 downto 0);
    signal leftShiftStage1Idx3_uid196_fracPostNorm_uid76_fpSubTest_q : STD_LOGIC_VECTOR (13 downto 0);
    signal leftShiftStage1_uid198_fracPostNorm_uid76_fpSubTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal leftShiftStage1_uid198_fracPostNorm_uid76_fpSubTest_q : STD_LOGIC_VECTOR (13 downto 0);
    signal rightShiftStageSel3Dto2_uid159_alignmentShifter_uid72_fpSubTest_merged_bit_select_in : STD_LOGIC_VECTOR (3 downto 0);
    signal rightShiftStageSel3Dto2_uid159_alignmentShifter_uid72_fpSubTest_merged_bit_select_b : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStageSel3Dto2_uid159_alignmentShifter_uid72_fpSubTest_merged_bit_select_c : STD_LOGIC_VECTOR (1 downto 0);
    signal rVStage_uid130_lzCountVal_uid75_fpSubTest_merged_bit_select_b : STD_LOGIC_VECTOR (3 downto 0);
    signal rVStage_uid130_lzCountVal_uid75_fpSubTest_merged_bit_select_c : STD_LOGIC_VECTOR (3 downto 0);
    signal rVStage_uid136_lzCountVal_uid75_fpSubTest_merged_bit_select_b : STD_LOGIC_VECTOR (1 downto 0);
    signal rVStage_uid136_lzCountVal_uid75_fpSubTest_merged_bit_select_c : STD_LOGIC_VECTOR (1 downto 0);
    signal leftShiftStageSel3Dto2_uid186_fracPostNorm_uid76_fpSubTest_merged_bit_select_b : STD_LOGIC_VECTOR (1 downto 0);
    signal leftShiftStageSel3Dto2_uid186_fracPostNorm_uid76_fpSubTest_merged_bit_select_c : STD_LOGIC_VECTOR (1 downto 0);
    signal redist0_rVStage_uid136_lzCountVal_uid75_fpSubTest_merged_bit_select_b_1_q : STD_LOGIC_VECTOR (1 downto 0);
    signal redist1_rVStage_uid136_lzCountVal_uid75_fpSubTest_merged_bit_select_c_1_q : STD_LOGIC_VECTOR (1 downto 0);
    signal redist2_vCount_uid131_lzCountVal_uid75_fpSubTest_q_1_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist3_vStage_uid125_lzCountVal_uid75_fpSubTest_b_2_q : STD_LOGIC_VECTOR (5 downto 0);
    signal redist4_vCount_uid123_lzCountVal_uid75_fpSubTest_q_2_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist5_excRInfVInC_uid93_fpSubTest_q_1_q : STD_LOGIC_VECTOR (5 downto 0);
    signal redist6_expRPreExc_uid88_fpSubTest_b_1_q : STD_LOGIC_VECTOR (4 downto 0);
    signal redist7_fracRPreExc_uid87_fpSubTest_b_1_q : STD_LOGIC_VECTOR (9 downto 0);
    signal redist8_fracPostNormRndRange_uid81_fpSubTest_b_1_q : STD_LOGIC_VECTOR (10 downto 0);
    signal redist9_fracAddResultNoSignExt_uid74_fpSubTest_b_1_q : STD_LOGIC_VECTOR (13 downto 0);
    signal redist10_fracAddResultNoSignExt_uid74_fpSubTest_b_3_q : STD_LOGIC_VECTOR (13 downto 0);
    signal redist11_oFracBREXC2_uid71_fpSubTest_b_1_q : STD_LOGIC_VECTOR (13 downto 0);
    signal redist12_effSub_uid53_fpSubTest_q_1_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist13_effSub_uid53_fpSubTest_q_7_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist14_sigB_uid52_fpSubTest_b_7_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist15_sigA_uid51_fpSubTest_b_7_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist16_InvExpXIsZero_uid45_fpSubTest_q_6_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist17_fracXIsZero_uid40_fpSubTest_q_6_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist18_expXIsMax_uid39_fpSubTest_q_5_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist19_excZ_bSig_uid18_uid38_fpSubTest_q_7_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist20_exp_bSig_uid36_fpSubTest_b_1_q : STD_LOGIC_VECTOR (4 downto 0);
    signal redist21_fracXIsZero_uid26_fpSubTest_q_3_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist22_excZ_aSig_uid17_uid24_fpSubTest_q_2_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist23_frac_aSig_uid23_fpSubTest_b_3_q : STD_LOGIC_VECTOR (9 downto 0);
    signal redist24_exp_aSig_uid22_fpSubTest_b_1_q : STD_LOGIC_VECTOR (4 downto 0);
    signal redist25_exp_aSig_uid22_fpSubTest_b_5_q : STD_LOGIC_VECTOR (4 downto 0);
    signal redist26_sigY_uid11_fpSubTest_b_1_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist27_expY_uid10_fpSubTest_b_1_q : STD_LOGIC_VECTOR (4 downto 0);
    signal redist28_fracY_uid9_fpSubTest_b_1_q : STD_LOGIC_VECTOR (9 downto 0);
    signal redist29_xIn_a_1_q : STD_LOGIC_VECTOR (15 downto 0);

begin


    -- cAmA_uid77_fpSubTest(CONSTANT,76)
    cAmA_uid77_fpSubTest_q <= "1110";

    -- zs_uid121_lzCountVal_uid75_fpSubTest(CONSTANT,120)
    zs_uid121_lzCountVal_uid75_fpSubTest_q <= "00000000";

    -- sigY_uid11_fpSubTest(BITSELECT,10)@0
    sigY_uid11_fpSubTest_b <= STD_LOGIC_VECTOR(b(15 downto 15));

    -- redist26_sigY_uid11_fpSubTest_b_1(DELAY,229)
    redist26_sigY_uid11_fpSubTest_b_1 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => sigY_uid11_fpSubTest_b, xout => redist26_sigY_uid11_fpSubTest_b_1_q, clk => clk, aclr => areset );

    -- invSigY_uid12_fpSubTest(LOGICAL,11)@1
    invSigY_uid12_fpSubTest_q <= not (redist26_sigY_uid11_fpSubTest_b_1_q);

    -- expY_uid10_fpSubTest(BITSELECT,9)@0
    expY_uid10_fpSubTest_b <= b(14 downto 10);

    -- redist27_expY_uid10_fpSubTest_b_1(DELAY,230)
    redist27_expY_uid10_fpSubTest_b_1 : dspba_delay
    GENERIC MAP ( width => 5, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => expY_uid10_fpSubTest_b, xout => redist27_expY_uid10_fpSubTest_b_1_q, clk => clk, aclr => areset );

    -- fracY_uid9_fpSubTest(BITSELECT,8)@0
    fracY_uid9_fpSubTest_b <= b(9 downto 0);

    -- redist28_fracY_uid9_fpSubTest_b_1(DELAY,231)
    redist28_fracY_uid9_fpSubTest_b_1 : dspba_delay
    GENERIC MAP ( width => 10, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracY_uid9_fpSubTest_b, xout => redist28_fracY_uid9_fpSubTest_b_1_q, clk => clk, aclr => areset );

    -- ypn_uid13_fpSubTest(BITJOIN,12)@1
    ypn_uid13_fpSubTest_q <= invSigY_uid12_fpSubTest_q & redist27_expY_uid10_fpSubTest_b_1_q & redist28_fracY_uid9_fpSubTest_b_1_q;

    -- redist29_xIn_a_1(DELAY,232)
    redist29_xIn_a_1 : dspba_delay
    GENERIC MAP ( width => 16, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => a, xout => redist29_xIn_a_1_q, clk => clk, aclr => areset );

    -- GND(CONSTANT,0)
    GND_q <= "0";

    -- expFracY_uid7_fpSubTest(BITSELECT,6)@0
    expFracY_uid7_fpSubTest_b <= b(14 downto 0);

    -- expFracX_uid6_fpSubTest(BITSELECT,5)@0
    expFracX_uid6_fpSubTest_b <= a(14 downto 0);

    -- xGTEy_uid8_fpSubTest(COMPARE,7)@0 + 1
    xGTEy_uid8_fpSubTest_a <= STD_LOGIC_VECTOR("00" & expFracX_uid6_fpSubTest_b);
    xGTEy_uid8_fpSubTest_b <= STD_LOGIC_VECTOR("00" & expFracY_uid7_fpSubTest_b);
    xGTEy_uid8_fpSubTest_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            xGTEy_uid8_fpSubTest_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            xGTEy_uid8_fpSubTest_o <= STD_LOGIC_VECTOR(UNSIGNED(xGTEy_uid8_fpSubTest_a) - UNSIGNED(xGTEy_uid8_fpSubTest_b));
        END IF;
    END PROCESS;
    xGTEy_uid8_fpSubTest_n(0) <= not (xGTEy_uid8_fpSubTest_o(16));

    -- bSig_uid18_fpSubTest(MUX,17)@1 + 1
    bSig_uid18_fpSubTest_s <= xGTEy_uid8_fpSubTest_n;
    bSig_uid18_fpSubTest_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            bSig_uid18_fpSubTest_q <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            CASE (bSig_uid18_fpSubTest_s) IS
                WHEN "0" => bSig_uid18_fpSubTest_q <= redist29_xIn_a_1_q;
                WHEN "1" => bSig_uid18_fpSubTest_q <= ypn_uid13_fpSubTest_q;
                WHEN OTHERS => bSig_uid18_fpSubTest_q <= (others => '0');
            END CASE;
        END IF;
    END PROCESS;

    -- sigB_uid52_fpSubTest(BITSELECT,51)@2
    sigB_uid52_fpSubTest_b <= STD_LOGIC_VECTOR(bSig_uid18_fpSubTest_q(15 downto 15));

    -- aSig_uid17_fpSubTest(MUX,16)@1 + 1
    aSig_uid17_fpSubTest_s <= xGTEy_uid8_fpSubTest_n;
    aSig_uid17_fpSubTest_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            aSig_uid17_fpSubTest_q <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            CASE (aSig_uid17_fpSubTest_s) IS
                WHEN "0" => aSig_uid17_fpSubTest_q <= ypn_uid13_fpSubTest_q;
                WHEN "1" => aSig_uid17_fpSubTest_q <= redist29_xIn_a_1_q;
                WHEN OTHERS => aSig_uid17_fpSubTest_q <= (others => '0');
            END CASE;
        END IF;
    END PROCESS;

    -- sigA_uid51_fpSubTest(BITSELECT,50)@2
    sigA_uid51_fpSubTest_b <= STD_LOGIC_VECTOR(aSig_uid17_fpSubTest_q(15 downto 15));

    -- effSub_uid53_fpSubTest(LOGICAL,52)@2
    effSub_uid53_fpSubTest_q <= sigA_uid51_fpSubTest_b xor sigB_uid52_fpSubTest_b;

    -- redist12_effSub_uid53_fpSubTest_q_1(DELAY,215)
    redist12_effSub_uid53_fpSubTest_q_1 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => effSub_uid53_fpSubTest_q, xout => redist12_effSub_uid53_fpSubTest_q_1_q, clk => clk, aclr => areset );

    -- cstAllZWE_uid21_fpSubTest(CONSTANT,20)
    cstAllZWE_uid21_fpSubTest_q <= "00000";

    -- exp_bSig_uid36_fpSubTest(BITSELECT,35)@2
    exp_bSig_uid36_fpSubTest_in <= bSig_uid18_fpSubTest_q(14 downto 0);
    exp_bSig_uid36_fpSubTest_b <= exp_bSig_uid36_fpSubTest_in(14 downto 10);

    -- excZ_bSig_uid18_uid38_fpSubTest(LOGICAL,37)@2
    excZ_bSig_uid18_uid38_fpSubTest_q <= "1" WHEN exp_bSig_uid36_fpSubTest_b = cstAllZWE_uid21_fpSubTest_q ELSE "0";

    -- InvExpXIsZero_uid45_fpSubTest(LOGICAL,44)@2
    InvExpXIsZero_uid45_fpSubTest_q <= not (excZ_bSig_uid18_uid38_fpSubTest_q);

    -- cstZeroWF_uid20_fpSubTest(CONSTANT,19)
    cstZeroWF_uid20_fpSubTest_q <= "0000000000";

    -- frac_bSig_uid37_fpSubTest(BITSELECT,36)@2
    frac_bSig_uid37_fpSubTest_in <= bSig_uid18_fpSubTest_q(9 downto 0);
    frac_bSig_uid37_fpSubTest_b <= frac_bSig_uid37_fpSubTest_in(9 downto 0);

    -- fracBz_uid57_fpSubTest(MUX,56)@2
    fracBz_uid57_fpSubTest_s <= excZ_bSig_uid18_uid38_fpSubTest_q;
    fracBz_uid57_fpSubTest_combproc: PROCESS (fracBz_uid57_fpSubTest_s, frac_bSig_uid37_fpSubTest_b, cstZeroWF_uid20_fpSubTest_q)
    BEGIN
        CASE (fracBz_uid57_fpSubTest_s) IS
            WHEN "0" => fracBz_uid57_fpSubTest_q <= frac_bSig_uid37_fpSubTest_b;
            WHEN "1" => fracBz_uid57_fpSubTest_q <= cstZeroWF_uid20_fpSubTest_q;
            WHEN OTHERS => fracBz_uid57_fpSubTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- oFracB_uid60_fpSubTest(BITJOIN,59)@2
    oFracB_uid60_fpSubTest_q <= InvExpXIsZero_uid45_fpSubTest_q & fracBz_uid57_fpSubTest_q;

    -- oFracBR_uid68_fpSubTest(BITJOIN,67)@2
    oFracBR_uid68_fpSubTest_q <= GND_q & oFracB_uid60_fpSubTest_q & GND_q & GND_q;

    -- oFracBREX_uid69_fpSubTest(LOGICAL,68)@2 + 1
    oFracBREX_uid69_fpSubTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((13 downto 1 => effSub_uid53_fpSubTest_q(0)) & effSub_uid53_fpSubTest_q));
    oFracBREX_uid69_fpSubTest_qi <= oFracBR_uid68_fpSubTest_q xor oFracBREX_uid69_fpSubTest_b;
    oFracBREX_uid69_fpSubTest_delay : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => oFracBREX_uid69_fpSubTest_qi, xout => oFracBREX_uid69_fpSubTest_q, clk => clk, aclr => areset );

    -- oFracBREXC2_uid70_fpSubTest(ADD,69)@3
    oFracBREXC2_uid70_fpSubTest_a <= STD_LOGIC_VECTOR("0" & oFracBREX_uid69_fpSubTest_q);
    oFracBREXC2_uid70_fpSubTest_b <= STD_LOGIC_VECTOR("00000000000000" & redist12_effSub_uid53_fpSubTest_q_1_q);
    oFracBREXC2_uid70_fpSubTest_o <= STD_LOGIC_VECTOR(UNSIGNED(oFracBREXC2_uid70_fpSubTest_a) + UNSIGNED(oFracBREXC2_uid70_fpSubTest_b));
    oFracBREXC2_uid70_fpSubTest_q <= oFracBREXC2_uid70_fpSubTest_o(14 downto 0);

    -- oFracBREXC2_uid71_fpSubTest(BITSELECT,70)@3
    oFracBREXC2_uid71_fpSubTest_in <= STD_LOGIC_VECTOR(oFracBREXC2_uid70_fpSubTest_q(13 downto 0));
    oFracBREXC2_uid71_fpSubTest_b <= STD_LOGIC_VECTOR(oFracBREXC2_uid71_fpSubTest_in(13 downto 0));

    -- redist11_oFracBREXC2_uid71_fpSubTest_b_1(DELAY,214)
    redist11_oFracBREXC2_uid71_fpSubTest_b_1 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => oFracBREXC2_uid71_fpSubTest_b, xout => redist11_oFracBREXC2_uid71_fpSubTest_b_1_q, clk => clk, aclr => areset );

    -- xMSB_uid146_alignmentShifter_uid72_fpSubTest(BITSELECT,145)@4
    xMSB_uid146_alignmentShifter_uid72_fpSubTest_b <= STD_LOGIC_VECTOR(redist11_oFracBREXC2_uid71_fpSubTest_b_1_q(13 downto 13));

    -- shiftOutConstant_to14_uid171(BITSELECT,170)@4
    shiftOutConstant_to14_uid171_in <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((13 downto 1 => xMSB_uid146_alignmentShifter_uid72_fpSubTest_b(0)) & xMSB_uid146_alignmentShifter_uid72_fpSubTest_b));
    shiftOutConstant_to14_uid171_b <= STD_LOGIC_VECTOR(shiftOutConstant_to14_uid171_in(13 downto 0));

    -- seMsb_to3_uid166(BITSELECT,165)@4
    seMsb_to3_uid166_in <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((2 downto 1 => xMSB_uid146_alignmentShifter_uid72_fpSubTest_b(0)) & xMSB_uid146_alignmentShifter_uid72_fpSubTest_b));
    seMsb_to3_uid166_b <= STD_LOGIC_VECTOR(seMsb_to3_uid166_in(2 downto 0));

    -- rightShiftStage1Idx3Rng3_uid167_alignmentShifter_uid72_fpSubTest(BITSELECT,166)@4
    rightShiftStage1Idx3Rng3_uid167_alignmentShifter_uid72_fpSubTest_b <= rightShiftStage0_uid160_alignmentShifter_uid72_fpSubTest_q(13 downto 3);

    -- rightShiftStage1Idx3_uid168_alignmentShifter_uid72_fpSubTest(BITJOIN,167)@4
    rightShiftStage1Idx3_uid168_alignmentShifter_uid72_fpSubTest_q <= seMsb_to3_uid166_b & rightShiftStage1Idx3Rng3_uid167_alignmentShifter_uid72_fpSubTest_b;

    -- seMsb_to2_uid163(BITSELECT,162)@4
    seMsb_to2_uid163_in <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((1 downto 1 => xMSB_uid146_alignmentShifter_uid72_fpSubTest_b(0)) & xMSB_uid146_alignmentShifter_uid72_fpSubTest_b));
    seMsb_to2_uid163_b <= STD_LOGIC_VECTOR(seMsb_to2_uid163_in(1 downto 0));

    -- rightShiftStage1Idx2Rng2_uid164_alignmentShifter_uid72_fpSubTest(BITSELECT,163)@4
    rightShiftStage1Idx2Rng2_uid164_alignmentShifter_uid72_fpSubTest_b <= rightShiftStage0_uid160_alignmentShifter_uid72_fpSubTest_q(13 downto 2);

    -- rightShiftStage1Idx2_uid165_alignmentShifter_uid72_fpSubTest(BITJOIN,164)@4
    rightShiftStage1Idx2_uid165_alignmentShifter_uid72_fpSubTest_q <= seMsb_to2_uid163_b & rightShiftStage1Idx2Rng2_uid164_alignmentShifter_uid72_fpSubTest_b;

    -- rightShiftStage1Idx1Rng1_uid161_alignmentShifter_uid72_fpSubTest(BITSELECT,160)@4
    rightShiftStage1Idx1Rng1_uid161_alignmentShifter_uid72_fpSubTest_b <= rightShiftStage0_uid160_alignmentShifter_uid72_fpSubTest_q(13 downto 1);

    -- rightShiftStage1Idx1_uid162_alignmentShifter_uid72_fpSubTest(BITJOIN,161)@4
    rightShiftStage1Idx1_uid162_alignmentShifter_uid72_fpSubTest_q <= xMSB_uid146_alignmentShifter_uid72_fpSubTest_b & rightShiftStage1Idx1Rng1_uid161_alignmentShifter_uid72_fpSubTest_b;

    -- seMsb_to12_uid156(BITSELECT,155)@4
    seMsb_to12_uid156_in <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((11 downto 1 => xMSB_uid146_alignmentShifter_uid72_fpSubTest_b(0)) & xMSB_uid146_alignmentShifter_uid72_fpSubTest_b));
    seMsb_to12_uid156_b <= STD_LOGIC_VECTOR(seMsb_to12_uid156_in(11 downto 0));

    -- rightShiftStage0Idx3Rng12_uid157_alignmentShifter_uid72_fpSubTest(BITSELECT,156)@4
    rightShiftStage0Idx3Rng12_uid157_alignmentShifter_uid72_fpSubTest_b <= redist11_oFracBREXC2_uid71_fpSubTest_b_1_q(13 downto 12);

    -- rightShiftStage0Idx3_uid158_alignmentShifter_uid72_fpSubTest(BITJOIN,157)@4
    rightShiftStage0Idx3_uid158_alignmentShifter_uid72_fpSubTest_q <= seMsb_to12_uid156_b & rightShiftStage0Idx3Rng12_uid157_alignmentShifter_uid72_fpSubTest_b;

    -- seMsb_to8_uid153(BITSELECT,152)@4
    seMsb_to8_uid153_in <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((7 downto 1 => xMSB_uid146_alignmentShifter_uid72_fpSubTest_b(0)) & xMSB_uid146_alignmentShifter_uid72_fpSubTest_b));
    seMsb_to8_uid153_b <= STD_LOGIC_VECTOR(seMsb_to8_uid153_in(7 downto 0));

    -- rightShiftStage0Idx2Rng8_uid154_alignmentShifter_uid72_fpSubTest(BITSELECT,153)@4
    rightShiftStage0Idx2Rng8_uid154_alignmentShifter_uid72_fpSubTest_b <= redist11_oFracBREXC2_uid71_fpSubTest_b_1_q(13 downto 8);

    -- rightShiftStage0Idx2_uid155_alignmentShifter_uid72_fpSubTest(BITJOIN,154)@4
    rightShiftStage0Idx2_uid155_alignmentShifter_uid72_fpSubTest_q <= seMsb_to8_uid153_b & rightShiftStage0Idx2Rng8_uid154_alignmentShifter_uid72_fpSubTest_b;

    -- seMsb_to4_uid150(BITSELECT,149)@4
    seMsb_to4_uid150_in <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((3 downto 1 => xMSB_uid146_alignmentShifter_uid72_fpSubTest_b(0)) & xMSB_uid146_alignmentShifter_uid72_fpSubTest_b));
    seMsb_to4_uid150_b <= STD_LOGIC_VECTOR(seMsb_to4_uid150_in(3 downto 0));

    -- rightShiftStage0Idx1Rng4_uid151_alignmentShifter_uid72_fpSubTest(BITSELECT,150)@4
    rightShiftStage0Idx1Rng4_uid151_alignmentShifter_uid72_fpSubTest_b <= redist11_oFracBREXC2_uid71_fpSubTest_b_1_q(13 downto 4);

    -- rightShiftStage0Idx1_uid152_alignmentShifter_uid72_fpSubTest(BITJOIN,151)@4
    rightShiftStage0Idx1_uid152_alignmentShifter_uid72_fpSubTest_q <= seMsb_to4_uid150_b & rightShiftStage0Idx1Rng4_uid151_alignmentShifter_uid72_fpSubTest_b;

    -- rightShiftStage0_uid160_alignmentShifter_uid72_fpSubTest(MUX,159)@4
    rightShiftStage0_uid160_alignmentShifter_uid72_fpSubTest_s <= rightShiftStageSel3Dto2_uid159_alignmentShifter_uid72_fpSubTest_merged_bit_select_b;
    rightShiftStage0_uid160_alignmentShifter_uid72_fpSubTest_combproc: PROCESS (rightShiftStage0_uid160_alignmentShifter_uid72_fpSubTest_s, redist11_oFracBREXC2_uid71_fpSubTest_b_1_q, rightShiftStage0Idx1_uid152_alignmentShifter_uid72_fpSubTest_q, rightShiftStage0Idx2_uid155_alignmentShifter_uid72_fpSubTest_q, rightShiftStage0Idx3_uid158_alignmentShifter_uid72_fpSubTest_q)
    BEGIN
        CASE (rightShiftStage0_uid160_alignmentShifter_uid72_fpSubTest_s) IS
            WHEN "00" => rightShiftStage0_uid160_alignmentShifter_uid72_fpSubTest_q <= redist11_oFracBREXC2_uid71_fpSubTest_b_1_q;
            WHEN "01" => rightShiftStage0_uid160_alignmentShifter_uid72_fpSubTest_q <= rightShiftStage0Idx1_uid152_alignmentShifter_uid72_fpSubTest_q;
            WHEN "10" => rightShiftStage0_uid160_alignmentShifter_uid72_fpSubTest_q <= rightShiftStage0Idx2_uid155_alignmentShifter_uid72_fpSubTest_q;
            WHEN "11" => rightShiftStage0_uid160_alignmentShifter_uid72_fpSubTest_q <= rightShiftStage0Idx3_uid158_alignmentShifter_uid72_fpSubTest_q;
            WHEN OTHERS => rightShiftStage0_uid160_alignmentShifter_uid72_fpSubTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- redist20_exp_bSig_uid36_fpSubTest_b_1(DELAY,223)
    redist20_exp_bSig_uid36_fpSubTest_b_1 : dspba_delay
    GENERIC MAP ( width => 5, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => exp_bSig_uid36_fpSubTest_b, xout => redist20_exp_bSig_uid36_fpSubTest_b_1_q, clk => clk, aclr => areset );

    -- exp_aSig_uid22_fpSubTest(BITSELECT,21)@2
    exp_aSig_uid22_fpSubTest_in <= aSig_uid17_fpSubTest_q(14 downto 0);
    exp_aSig_uid22_fpSubTest_b <= exp_aSig_uid22_fpSubTest_in(14 downto 10);

    -- redist24_exp_aSig_uid22_fpSubTest_b_1(DELAY,227)
    redist24_exp_aSig_uid22_fpSubTest_b_1 : dspba_delay
    GENERIC MAP ( width => 5, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => exp_aSig_uid22_fpSubTest_b, xout => redist24_exp_aSig_uid22_fpSubTest_b_1_q, clk => clk, aclr => areset );

    -- expAmExpB_uid61_fpSubTest(SUB,60)@3 + 1
    expAmExpB_uid61_fpSubTest_a <= STD_LOGIC_VECTOR("0" & redist24_exp_aSig_uid22_fpSubTest_b_1_q);
    expAmExpB_uid61_fpSubTest_b <= STD_LOGIC_VECTOR("0" & redist20_exp_bSig_uid36_fpSubTest_b_1_q);
    expAmExpB_uid61_fpSubTest_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            expAmExpB_uid61_fpSubTest_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            expAmExpB_uid61_fpSubTest_o <= STD_LOGIC_VECTOR(UNSIGNED(expAmExpB_uid61_fpSubTest_a) - UNSIGNED(expAmExpB_uid61_fpSubTest_b));
        END IF;
    END PROCESS;
    expAmExpB_uid61_fpSubTest_q <= expAmExpB_uid61_fpSubTest_o(5 downto 0);

    -- rightShiftStageSel3Dto2_uid159_alignmentShifter_uid72_fpSubTest_merged_bit_select(BITSELECT,199)@4
    rightShiftStageSel3Dto2_uid159_alignmentShifter_uid72_fpSubTest_merged_bit_select_in <= expAmExpB_uid61_fpSubTest_q(3 downto 0);
    rightShiftStageSel3Dto2_uid159_alignmentShifter_uid72_fpSubTest_merged_bit_select_b <= rightShiftStageSel3Dto2_uid159_alignmentShifter_uid72_fpSubTest_merged_bit_select_in(3 downto 2);
    rightShiftStageSel3Dto2_uid159_alignmentShifter_uid72_fpSubTest_merged_bit_select_c <= rightShiftStageSel3Dto2_uid159_alignmentShifter_uid72_fpSubTest_merged_bit_select_in(1 downto 0);

    -- rightShiftStage1_uid170_alignmentShifter_uid72_fpSubTest(MUX,169)@4
    rightShiftStage1_uid170_alignmentShifter_uid72_fpSubTest_s <= rightShiftStageSel3Dto2_uid159_alignmentShifter_uid72_fpSubTest_merged_bit_select_c;
    rightShiftStage1_uid170_alignmentShifter_uid72_fpSubTest_combproc: PROCESS (rightShiftStage1_uid170_alignmentShifter_uid72_fpSubTest_s, rightShiftStage0_uid160_alignmentShifter_uid72_fpSubTest_q, rightShiftStage1Idx1_uid162_alignmentShifter_uid72_fpSubTest_q, rightShiftStage1Idx2_uid165_alignmentShifter_uid72_fpSubTest_q, rightShiftStage1Idx3_uid168_alignmentShifter_uid72_fpSubTest_q)
    BEGIN
        CASE (rightShiftStage1_uid170_alignmentShifter_uid72_fpSubTest_s) IS
            WHEN "00" => rightShiftStage1_uid170_alignmentShifter_uid72_fpSubTest_q <= rightShiftStage0_uid160_alignmentShifter_uid72_fpSubTest_q;
            WHEN "01" => rightShiftStage1_uid170_alignmentShifter_uid72_fpSubTest_q <= rightShiftStage1Idx1_uid162_alignmentShifter_uid72_fpSubTest_q;
            WHEN "10" => rightShiftStage1_uid170_alignmentShifter_uid72_fpSubTest_q <= rightShiftStage1Idx2_uid165_alignmentShifter_uid72_fpSubTest_q;
            WHEN "11" => rightShiftStage1_uid170_alignmentShifter_uid72_fpSubTest_q <= rightShiftStage1Idx3_uid168_alignmentShifter_uid72_fpSubTest_q;
            WHEN OTHERS => rightShiftStage1_uid170_alignmentShifter_uid72_fpSubTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- shiftedOut_uid149_alignmentShifter_uid72_fpSubTest(COMPARE,148)@4
    shiftedOut_uid149_alignmentShifter_uid72_fpSubTest_a <= STD_LOGIC_VECTOR("00" & expAmExpB_uid61_fpSubTest_q);
    shiftedOut_uid149_alignmentShifter_uid72_fpSubTest_b <= STD_LOGIC_VECTOR("0000" & cAmA_uid77_fpSubTest_q);
    shiftedOut_uid149_alignmentShifter_uid72_fpSubTest_o <= STD_LOGIC_VECTOR(UNSIGNED(shiftedOut_uid149_alignmentShifter_uid72_fpSubTest_a) - UNSIGNED(shiftedOut_uid149_alignmentShifter_uid72_fpSubTest_b));
    shiftedOut_uid149_alignmentShifter_uid72_fpSubTest_n(0) <= not (shiftedOut_uid149_alignmentShifter_uid72_fpSubTest_o(7));

    -- r_uid173_alignmentShifter_uid72_fpSubTest(MUX,172)@4 + 1
    r_uid173_alignmentShifter_uid72_fpSubTest_s <= shiftedOut_uid149_alignmentShifter_uid72_fpSubTest_n;
    r_uid173_alignmentShifter_uid72_fpSubTest_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            r_uid173_alignmentShifter_uid72_fpSubTest_q <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            CASE (r_uid173_alignmentShifter_uid72_fpSubTest_s) IS
                WHEN "0" => r_uid173_alignmentShifter_uid72_fpSubTest_q <= rightShiftStage1_uid170_alignmentShifter_uid72_fpSubTest_q;
                WHEN "1" => r_uid173_alignmentShifter_uid72_fpSubTest_q <= shiftOutConstant_to14_uid171_b;
                WHEN OTHERS => r_uid173_alignmentShifter_uid72_fpSubTest_q <= (others => '0');
            END CASE;
        END IF;
    END PROCESS;

    -- frac_aSig_uid23_fpSubTest(BITSELECT,22)@2
    frac_aSig_uid23_fpSubTest_in <= aSig_uid17_fpSubTest_q(9 downto 0);
    frac_aSig_uid23_fpSubTest_b <= frac_aSig_uid23_fpSubTest_in(9 downto 0);

    -- redist23_frac_aSig_uid23_fpSubTest_b_3(DELAY,226)
    redist23_frac_aSig_uid23_fpSubTest_b_3 : dspba_delay
    GENERIC MAP ( width => 10, depth => 3, reset_kind => "ASYNC" )
    PORT MAP ( xin => frac_aSig_uid23_fpSubTest_b, xout => redist23_frac_aSig_uid23_fpSubTest_b_3_q, clk => clk, aclr => areset );

    -- oFracA_uid65_fpSubTest(BITJOIN,64)@5
    oFracA_uid65_fpSubTest_q <= VCC_q & redist23_frac_aSig_uid23_fpSubTest_b_3_q;

    -- oFracAE_uid66_fpSubTest(BITJOIN,65)@5
    oFracAE_uid66_fpSubTest_q <= GND_q & oFracA_uid65_fpSubTest_q & GND_q & GND_q;

    -- fracAddResult_uid73_fpSubTest(ADD,72)@5
    fracAddResult_uid73_fpSubTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((14 downto 14 => oFracAE_uid66_fpSubTest_q(13)) & oFracAE_uid66_fpSubTest_q));
    fracAddResult_uid73_fpSubTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((14 downto 14 => r_uid173_alignmentShifter_uid72_fpSubTest_q(13)) & r_uid173_alignmentShifter_uid72_fpSubTest_q));
    fracAddResult_uid73_fpSubTest_o <= STD_LOGIC_VECTOR(SIGNED(fracAddResult_uid73_fpSubTest_a) + SIGNED(fracAddResult_uid73_fpSubTest_b));
    fracAddResult_uid73_fpSubTest_q <= fracAddResult_uid73_fpSubTest_o(14 downto 0);

    -- fracAddResultNoSignExt_uid74_fpSubTest(BITSELECT,73)@5
    fracAddResultNoSignExt_uid74_fpSubTest_in <= fracAddResult_uid73_fpSubTest_q(13 downto 0);
    fracAddResultNoSignExt_uid74_fpSubTest_b <= fracAddResultNoSignExt_uid74_fpSubTest_in(13 downto 0);

    -- redist9_fracAddResultNoSignExt_uid74_fpSubTest_b_1(DELAY,212)
    redist9_fracAddResultNoSignExt_uid74_fpSubTest_b_1 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracAddResultNoSignExt_uid74_fpSubTest_b, xout => redist9_fracAddResultNoSignExt_uid74_fpSubTest_b_1_q, clk => clk, aclr => areset );

    -- rVStage_uid122_lzCountVal_uid75_fpSubTest(BITSELECT,121)@6
    rVStage_uid122_lzCountVal_uid75_fpSubTest_b <= redist9_fracAddResultNoSignExt_uid74_fpSubTest_b_1_q(13 downto 6);

    -- vCount_uid123_lzCountVal_uid75_fpSubTest(LOGICAL,122)@6
    vCount_uid123_lzCountVal_uid75_fpSubTest_q <= "1" WHEN rVStage_uid122_lzCountVal_uid75_fpSubTest_b = zs_uid121_lzCountVal_uid75_fpSubTest_q ELSE "0";

    -- redist4_vCount_uid123_lzCountVal_uid75_fpSubTest_q_2(DELAY,207)
    redist4_vCount_uid123_lzCountVal_uid75_fpSubTest_q_2 : dspba_delay
    GENERIC MAP ( width => 1, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => vCount_uid123_lzCountVal_uid75_fpSubTest_q, xout => redist4_vCount_uid123_lzCountVal_uid75_fpSubTest_q_2_q, clk => clk, aclr => areset );

    -- zs_uid129_lzCountVal_uid75_fpSubTest(CONSTANT,128)
    zs_uid129_lzCountVal_uid75_fpSubTest_q <= "0000";

    -- vStage_uid125_lzCountVal_uid75_fpSubTest(BITSELECT,124)@6
    vStage_uid125_lzCountVal_uid75_fpSubTest_in <= redist9_fracAddResultNoSignExt_uid74_fpSubTest_b_1_q(5 downto 0);
    vStage_uid125_lzCountVal_uid75_fpSubTest_b <= vStage_uid125_lzCountVal_uid75_fpSubTest_in(5 downto 0);

    -- mO_uid124_lzCountVal_uid75_fpSubTest(CONSTANT,123)
    mO_uid124_lzCountVal_uid75_fpSubTest_q <= "11";

    -- cStage_uid126_lzCountVal_uid75_fpSubTest(BITJOIN,125)@6
    cStage_uid126_lzCountVal_uid75_fpSubTest_q <= vStage_uid125_lzCountVal_uid75_fpSubTest_b & mO_uid124_lzCountVal_uid75_fpSubTest_q;

    -- vStagei_uid128_lzCountVal_uid75_fpSubTest(MUX,127)@6 + 1
    vStagei_uid128_lzCountVal_uid75_fpSubTest_s <= vCount_uid123_lzCountVal_uid75_fpSubTest_q;
    vStagei_uid128_lzCountVal_uid75_fpSubTest_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            vStagei_uid128_lzCountVal_uid75_fpSubTest_q <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            CASE (vStagei_uid128_lzCountVal_uid75_fpSubTest_s) IS
                WHEN "0" => vStagei_uid128_lzCountVal_uid75_fpSubTest_q <= rVStage_uid122_lzCountVal_uid75_fpSubTest_b;
                WHEN "1" => vStagei_uid128_lzCountVal_uid75_fpSubTest_q <= cStage_uid126_lzCountVal_uid75_fpSubTest_q;
                WHEN OTHERS => vStagei_uid128_lzCountVal_uid75_fpSubTest_q <= (others => '0');
            END CASE;
        END IF;
    END PROCESS;

    -- rVStage_uid130_lzCountVal_uid75_fpSubTest_merged_bit_select(BITSELECT,200)@7
    rVStage_uid130_lzCountVal_uid75_fpSubTest_merged_bit_select_b <= vStagei_uid128_lzCountVal_uid75_fpSubTest_q(7 downto 4);
    rVStage_uid130_lzCountVal_uid75_fpSubTest_merged_bit_select_c <= vStagei_uid128_lzCountVal_uid75_fpSubTest_q(3 downto 0);

    -- vCount_uid131_lzCountVal_uid75_fpSubTest(LOGICAL,130)@7
    vCount_uid131_lzCountVal_uid75_fpSubTest_q <= "1" WHEN rVStage_uid130_lzCountVal_uid75_fpSubTest_merged_bit_select_b = zs_uid129_lzCountVal_uid75_fpSubTest_q ELSE "0";

    -- redist2_vCount_uid131_lzCountVal_uid75_fpSubTest_q_1(DELAY,205)
    redist2_vCount_uid131_lzCountVal_uid75_fpSubTest_q_1 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => vCount_uid131_lzCountVal_uid75_fpSubTest_q, xout => redist2_vCount_uid131_lzCountVal_uid75_fpSubTest_q_1_q, clk => clk, aclr => areset );

    -- zs_uid135_lzCountVal_uid75_fpSubTest(CONSTANT,134)
    zs_uid135_lzCountVal_uid75_fpSubTest_q <= "00";

    -- vStagei_uid134_lzCountVal_uid75_fpSubTest(MUX,133)@7
    vStagei_uid134_lzCountVal_uid75_fpSubTest_s <= vCount_uid131_lzCountVal_uid75_fpSubTest_q;
    vStagei_uid134_lzCountVal_uid75_fpSubTest_combproc: PROCESS (vStagei_uid134_lzCountVal_uid75_fpSubTest_s, rVStage_uid130_lzCountVal_uid75_fpSubTest_merged_bit_select_b, rVStage_uid130_lzCountVal_uid75_fpSubTest_merged_bit_select_c)
    BEGIN
        CASE (vStagei_uid134_lzCountVal_uid75_fpSubTest_s) IS
            WHEN "0" => vStagei_uid134_lzCountVal_uid75_fpSubTest_q <= rVStage_uid130_lzCountVal_uid75_fpSubTest_merged_bit_select_b;
            WHEN "1" => vStagei_uid134_lzCountVal_uid75_fpSubTest_q <= rVStage_uid130_lzCountVal_uid75_fpSubTest_merged_bit_select_c;
            WHEN OTHERS => vStagei_uid134_lzCountVal_uid75_fpSubTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- rVStage_uid136_lzCountVal_uid75_fpSubTest_merged_bit_select(BITSELECT,201)@7
    rVStage_uid136_lzCountVal_uid75_fpSubTest_merged_bit_select_b <= vStagei_uid134_lzCountVal_uid75_fpSubTest_q(3 downto 2);
    rVStage_uid136_lzCountVal_uid75_fpSubTest_merged_bit_select_c <= vStagei_uid134_lzCountVal_uid75_fpSubTest_q(1 downto 0);

    -- vCount_uid137_lzCountVal_uid75_fpSubTest(LOGICAL,136)@7 + 1
    vCount_uid137_lzCountVal_uid75_fpSubTest_qi <= "1" WHEN rVStage_uid136_lzCountVal_uid75_fpSubTest_merged_bit_select_b = zs_uid135_lzCountVal_uid75_fpSubTest_q ELSE "0";
    vCount_uid137_lzCountVal_uid75_fpSubTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => vCount_uid137_lzCountVal_uid75_fpSubTest_qi, xout => vCount_uid137_lzCountVal_uid75_fpSubTest_q, clk => clk, aclr => areset );

    -- redist1_rVStage_uid136_lzCountVal_uid75_fpSubTest_merged_bit_select_c_1(DELAY,204)
    redist1_rVStage_uid136_lzCountVal_uid75_fpSubTest_merged_bit_select_c_1 : dspba_delay
    GENERIC MAP ( width => 2, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => rVStage_uid136_lzCountVal_uid75_fpSubTest_merged_bit_select_c, xout => redist1_rVStage_uid136_lzCountVal_uid75_fpSubTest_merged_bit_select_c_1_q, clk => clk, aclr => areset );

    -- redist0_rVStage_uid136_lzCountVal_uid75_fpSubTest_merged_bit_select_b_1(DELAY,203)
    redist0_rVStage_uid136_lzCountVal_uid75_fpSubTest_merged_bit_select_b_1 : dspba_delay
    GENERIC MAP ( width => 2, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => rVStage_uid136_lzCountVal_uid75_fpSubTest_merged_bit_select_b, xout => redist0_rVStage_uid136_lzCountVal_uid75_fpSubTest_merged_bit_select_b_1_q, clk => clk, aclr => areset );

    -- vStagei_uid140_lzCountVal_uid75_fpSubTest(MUX,139)@8
    vStagei_uid140_lzCountVal_uid75_fpSubTest_s <= vCount_uid137_lzCountVal_uid75_fpSubTest_q;
    vStagei_uid140_lzCountVal_uid75_fpSubTest_combproc: PROCESS (vStagei_uid140_lzCountVal_uid75_fpSubTest_s, redist0_rVStage_uid136_lzCountVal_uid75_fpSubTest_merged_bit_select_b_1_q, redist1_rVStage_uid136_lzCountVal_uid75_fpSubTest_merged_bit_select_c_1_q)
    BEGIN
        CASE (vStagei_uid140_lzCountVal_uid75_fpSubTest_s) IS
            WHEN "0" => vStagei_uid140_lzCountVal_uid75_fpSubTest_q <= redist0_rVStage_uid136_lzCountVal_uid75_fpSubTest_merged_bit_select_b_1_q;
            WHEN "1" => vStagei_uid140_lzCountVal_uid75_fpSubTest_q <= redist1_rVStage_uid136_lzCountVal_uid75_fpSubTest_merged_bit_select_c_1_q;
            WHEN OTHERS => vStagei_uid140_lzCountVal_uid75_fpSubTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- rVStage_uid142_lzCountVal_uid75_fpSubTest(BITSELECT,141)@8
    rVStage_uid142_lzCountVal_uid75_fpSubTest_b <= vStagei_uid140_lzCountVal_uid75_fpSubTest_q(1 downto 1);

    -- vCount_uid143_lzCountVal_uid75_fpSubTest(LOGICAL,142)@8
    vCount_uid143_lzCountVal_uid75_fpSubTest_q <= "1" WHEN rVStage_uid142_lzCountVal_uid75_fpSubTest_b = GND_q ELSE "0";

    -- r_uid144_lzCountVal_uid75_fpSubTest(BITJOIN,143)@8
    r_uid144_lzCountVal_uid75_fpSubTest_q <= redist4_vCount_uid123_lzCountVal_uid75_fpSubTest_q_2_q & redist2_vCount_uid131_lzCountVal_uid75_fpSubTest_q_1_q & vCount_uid137_lzCountVal_uid75_fpSubTest_q & vCount_uid143_lzCountVal_uid75_fpSubTest_q;

    -- aMinusA_uid78_fpSubTest(LOGICAL,77)@8 + 1
    aMinusA_uid78_fpSubTest_qi <= "1" WHEN r_uid144_lzCountVal_uid75_fpSubTest_q = cAmA_uid77_fpSubTest_q ELSE "0";
    aMinusA_uid78_fpSubTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => aMinusA_uid78_fpSubTest_qi, xout => aMinusA_uid78_fpSubTest_q, clk => clk, aclr => areset );

    -- invAMinusA_uid100_fpSubTest(LOGICAL,99)@9
    invAMinusA_uid100_fpSubTest_q <= not (aMinusA_uid78_fpSubTest_q);

    -- redist15_sigA_uid51_fpSubTest_b_7(DELAY,218)
    redist15_sigA_uid51_fpSubTest_b_7 : dspba_delay
    GENERIC MAP ( width => 1, depth => 7, reset_kind => "ASYNC" )
    PORT MAP ( xin => sigA_uid51_fpSubTest_b, xout => redist15_sigA_uid51_fpSubTest_b_7_q, clk => clk, aclr => areset );

    -- cstAllOWE_uid19_fpSubTest(CONSTANT,18)
    cstAllOWE_uid19_fpSubTest_q <= "11111";

    -- expXIsMax_uid39_fpSubTest(LOGICAL,38)@3 + 1
    expXIsMax_uid39_fpSubTest_qi <= "1" WHEN redist20_exp_bSig_uid36_fpSubTest_b_1_q = cstAllOWE_uid19_fpSubTest_q ELSE "0";
    expXIsMax_uid39_fpSubTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => expXIsMax_uid39_fpSubTest_qi, xout => expXIsMax_uid39_fpSubTest_q, clk => clk, aclr => areset );

    -- redist18_expXIsMax_uid39_fpSubTest_q_5(DELAY,221)
    redist18_expXIsMax_uid39_fpSubTest_q_5 : dspba_delay
    GENERIC MAP ( width => 1, depth => 4, reset_kind => "ASYNC" )
    PORT MAP ( xin => expXIsMax_uid39_fpSubTest_q, xout => redist18_expXIsMax_uid39_fpSubTest_q_5_q, clk => clk, aclr => areset );

    -- invExpXIsMax_uid44_fpSubTest(LOGICAL,43)@8
    invExpXIsMax_uid44_fpSubTest_q <= not (redist18_expXIsMax_uid39_fpSubTest_q_5_q);

    -- redist16_InvExpXIsZero_uid45_fpSubTest_q_6(DELAY,219)
    redist16_InvExpXIsZero_uid45_fpSubTest_q_6 : dspba_delay
    GENERIC MAP ( width => 1, depth => 6, reset_kind => "ASYNC" )
    PORT MAP ( xin => InvExpXIsZero_uid45_fpSubTest_q, xout => redist16_InvExpXIsZero_uid45_fpSubTest_q_6_q, clk => clk, aclr => areset );

    -- excR_bSig_uid46_fpSubTest(LOGICAL,45)@8 + 1
    excR_bSig_uid46_fpSubTest_qi <= redist16_InvExpXIsZero_uid45_fpSubTest_q_6_q and invExpXIsMax_uid44_fpSubTest_q;
    excR_bSig_uid46_fpSubTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => excR_bSig_uid46_fpSubTest_qi, xout => excR_bSig_uid46_fpSubTest_q, clk => clk, aclr => areset );

    -- redist25_exp_aSig_uid22_fpSubTest_b_5(DELAY,228)
    redist25_exp_aSig_uid22_fpSubTest_b_5 : dspba_delay
    GENERIC MAP ( width => 5, depth => 4, reset_kind => "ASYNC" )
    PORT MAP ( xin => redist24_exp_aSig_uid22_fpSubTest_b_1_q, xout => redist25_exp_aSig_uid22_fpSubTest_b_5_q, clk => clk, aclr => areset );

    -- expXIsMax_uid25_fpSubTest(LOGICAL,24)@7 + 1
    expXIsMax_uid25_fpSubTest_qi <= "1" WHEN redist25_exp_aSig_uid22_fpSubTest_b_5_q = cstAllOWE_uid19_fpSubTest_q ELSE "0";
    expXIsMax_uid25_fpSubTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => expXIsMax_uid25_fpSubTest_qi, xout => expXIsMax_uid25_fpSubTest_q, clk => clk, aclr => areset );

    -- invExpXIsMax_uid30_fpSubTest(LOGICAL,29)@8
    invExpXIsMax_uid30_fpSubTest_q <= not (expXIsMax_uid25_fpSubTest_q);

    -- excZ_aSig_uid17_uid24_fpSubTest(LOGICAL,23)@7 + 1
    excZ_aSig_uid17_uid24_fpSubTest_qi <= "1" WHEN redist25_exp_aSig_uid22_fpSubTest_b_5_q = cstAllZWE_uid21_fpSubTest_q ELSE "0";
    excZ_aSig_uid17_uid24_fpSubTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => excZ_aSig_uid17_uid24_fpSubTest_qi, xout => excZ_aSig_uid17_uid24_fpSubTest_q, clk => clk, aclr => areset );

    -- InvExpXIsZero_uid31_fpSubTest(LOGICAL,30)@8
    InvExpXIsZero_uid31_fpSubTest_q <= not (excZ_aSig_uid17_uid24_fpSubTest_q);

    -- excR_aSig_uid32_fpSubTest(LOGICAL,31)@8 + 1
    excR_aSig_uid32_fpSubTest_qi <= InvExpXIsZero_uid31_fpSubTest_q and invExpXIsMax_uid30_fpSubTest_q;
    excR_aSig_uid32_fpSubTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => excR_aSig_uid32_fpSubTest_qi, xout => excR_aSig_uid32_fpSubTest_q, clk => clk, aclr => areset );

    -- signRReg_uid101_fpSubTest(LOGICAL,100)@9
    signRReg_uid101_fpSubTest_q <= excR_aSig_uid32_fpSubTest_q and excR_bSig_uid46_fpSubTest_q and redist15_sigA_uid51_fpSubTest_b_7_q and invAMinusA_uid100_fpSubTest_q;

    -- redist14_sigB_uid52_fpSubTest_b_7(DELAY,217)
    redist14_sigB_uid52_fpSubTest_b_7 : dspba_delay
    GENERIC MAP ( width => 1, depth => 7, reset_kind => "ASYNC" )
    PORT MAP ( xin => sigB_uid52_fpSubTest_b, xout => redist14_sigB_uid52_fpSubTest_b_7_q, clk => clk, aclr => areset );

    -- redist19_excZ_bSig_uid18_uid38_fpSubTest_q_7(DELAY,222)
    redist19_excZ_bSig_uid18_uid38_fpSubTest_q_7 : dspba_delay
    GENERIC MAP ( width => 1, depth => 7, reset_kind => "ASYNC" )
    PORT MAP ( xin => excZ_bSig_uid18_uid38_fpSubTest_q, xout => redist19_excZ_bSig_uid18_uid38_fpSubTest_q_7_q, clk => clk, aclr => areset );

    -- redist22_excZ_aSig_uid17_uid24_fpSubTest_q_2(DELAY,225)
    redist22_excZ_aSig_uid17_uid24_fpSubTest_q_2 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => excZ_aSig_uid17_uid24_fpSubTest_q, xout => redist22_excZ_aSig_uid17_uid24_fpSubTest_q_2_q, clk => clk, aclr => areset );

    -- excAZBZSigASigB_uid105_fpSubTest(LOGICAL,104)@9
    excAZBZSigASigB_uid105_fpSubTest_q <= redist22_excZ_aSig_uid17_uid24_fpSubTest_q_2_q and redist19_excZ_bSig_uid18_uid38_fpSubTest_q_7_q and redist15_sigA_uid51_fpSubTest_b_7_q and redist14_sigB_uid52_fpSubTest_b_7_q;

    -- excBZARSigA_uid106_fpSubTest(LOGICAL,105)@9
    excBZARSigA_uid106_fpSubTest_q <= redist19_excZ_bSig_uid18_uid38_fpSubTest_q_7_q and excR_aSig_uid32_fpSubTest_q and redist15_sigA_uid51_fpSubTest_b_7_q;

    -- signRZero_uid107_fpSubTest(LOGICAL,106)@9
    signRZero_uid107_fpSubTest_q <= excBZARSigA_uid106_fpSubTest_q or excAZBZSigASigB_uid105_fpSubTest_q;

    -- fracXIsZero_uid40_fpSubTest(LOGICAL,39)@2 + 1
    fracXIsZero_uid40_fpSubTest_qi <= "1" WHEN cstZeroWF_uid20_fpSubTest_q = frac_bSig_uid37_fpSubTest_b ELSE "0";
    fracXIsZero_uid40_fpSubTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracXIsZero_uid40_fpSubTest_qi, xout => fracXIsZero_uid40_fpSubTest_q, clk => clk, aclr => areset );

    -- redist17_fracXIsZero_uid40_fpSubTest_q_6(DELAY,220)
    redist17_fracXIsZero_uid40_fpSubTest_q_6 : dspba_delay
    GENERIC MAP ( width => 1, depth => 5, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracXIsZero_uid40_fpSubTest_q, xout => redist17_fracXIsZero_uid40_fpSubTest_q_6_q, clk => clk, aclr => areset );

    -- excI_bSig_uid42_fpSubTest(LOGICAL,41)@8 + 1
    excI_bSig_uid42_fpSubTest_qi <= redist18_expXIsMax_uid39_fpSubTest_q_5_q and redist17_fracXIsZero_uid40_fpSubTest_q_6_q;
    excI_bSig_uid42_fpSubTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => excI_bSig_uid42_fpSubTest_qi, xout => excI_bSig_uid42_fpSubTest_q, clk => clk, aclr => areset );

    -- sigBBInf_uid102_fpSubTest(LOGICAL,101)@9
    sigBBInf_uid102_fpSubTest_q <= redist14_sigB_uid52_fpSubTest_b_7_q and excI_bSig_uid42_fpSubTest_q;

    -- fracXIsZero_uid26_fpSubTest(LOGICAL,25)@5 + 1
    fracXIsZero_uid26_fpSubTest_qi <= "1" WHEN cstZeroWF_uid20_fpSubTest_q = redist23_frac_aSig_uid23_fpSubTest_b_3_q ELSE "0";
    fracXIsZero_uid26_fpSubTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracXIsZero_uid26_fpSubTest_qi, xout => fracXIsZero_uid26_fpSubTest_q, clk => clk, aclr => areset );

    -- redist21_fracXIsZero_uid26_fpSubTest_q_3(DELAY,224)
    redist21_fracXIsZero_uid26_fpSubTest_q_3 : dspba_delay
    GENERIC MAP ( width => 1, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracXIsZero_uid26_fpSubTest_q, xout => redist21_fracXIsZero_uid26_fpSubTest_q_3_q, clk => clk, aclr => areset );

    -- excI_aSig_uid28_fpSubTest(LOGICAL,27)@8 + 1
    excI_aSig_uid28_fpSubTest_qi <= expXIsMax_uid25_fpSubTest_q and redist21_fracXIsZero_uid26_fpSubTest_q_3_q;
    excI_aSig_uid28_fpSubTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => excI_aSig_uid28_fpSubTest_qi, xout => excI_aSig_uid28_fpSubTest_q, clk => clk, aclr => areset );

    -- sigAAInf_uid103_fpSubTest(LOGICAL,102)@9
    sigAAInf_uid103_fpSubTest_q <= redist15_sigA_uid51_fpSubTest_b_7_q and excI_aSig_uid28_fpSubTest_q;

    -- signRInf_uid104_fpSubTest(LOGICAL,103)@9
    signRInf_uid104_fpSubTest_q <= sigAAInf_uid103_fpSubTest_q or sigBBInf_uid102_fpSubTest_q;

    -- signRInfRZRReg_uid108_fpSubTest(LOGICAL,107)@9 + 1
    signRInfRZRReg_uid108_fpSubTest_qi <= signRInf_uid104_fpSubTest_q or signRZero_uid107_fpSubTest_q or signRReg_uid101_fpSubTest_q;
    signRInfRZRReg_uid108_fpSubTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => signRInfRZRReg_uid108_fpSubTest_qi, xout => signRInfRZRReg_uid108_fpSubTest_q, clk => clk, aclr => areset );

    -- fracXIsNotZero_uid41_fpSubTest(LOGICAL,40)@8
    fracXIsNotZero_uid41_fpSubTest_q <= not (redist17_fracXIsZero_uid40_fpSubTest_q_6_q);

    -- excN_bSig_uid43_fpSubTest(LOGICAL,42)@8 + 1
    excN_bSig_uid43_fpSubTest_qi <= redist18_expXIsMax_uid39_fpSubTest_q_5_q and fracXIsNotZero_uid41_fpSubTest_q;
    excN_bSig_uid43_fpSubTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => excN_bSig_uid43_fpSubTest_qi, xout => excN_bSig_uid43_fpSubTest_q, clk => clk, aclr => areset );

    -- fracXIsNotZero_uid27_fpSubTest(LOGICAL,26)@8
    fracXIsNotZero_uid27_fpSubTest_q <= not (redist21_fracXIsZero_uid26_fpSubTest_q_3_q);

    -- excN_aSig_uid29_fpSubTest(LOGICAL,28)@8 + 1
    excN_aSig_uid29_fpSubTest_qi <= expXIsMax_uid25_fpSubTest_q and fracXIsNotZero_uid27_fpSubTest_q;
    excN_aSig_uid29_fpSubTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => excN_aSig_uid29_fpSubTest_qi, xout => excN_aSig_uid29_fpSubTest_q, clk => clk, aclr => areset );

    -- excRNaN2_uid95_fpSubTest(LOGICAL,94)@9
    excRNaN2_uid95_fpSubTest_q <= excN_aSig_uid29_fpSubTest_q or excN_bSig_uid43_fpSubTest_q;

    -- redist13_effSub_uid53_fpSubTest_q_7(DELAY,216)
    redist13_effSub_uid53_fpSubTest_q_7 : dspba_delay
    GENERIC MAP ( width => 1, depth => 6, reset_kind => "ASYNC" )
    PORT MAP ( xin => redist12_effSub_uid53_fpSubTest_q_1_q, xout => redist13_effSub_uid53_fpSubTest_q_7_q, clk => clk, aclr => areset );

    -- excAIBISub_uid96_fpSubTest(LOGICAL,95)@9
    excAIBISub_uid96_fpSubTest_q <= excI_aSig_uid28_fpSubTest_q and excI_bSig_uid42_fpSubTest_q and redist13_effSub_uid53_fpSubTest_q_7_q;

    -- excRNaN_uid97_fpSubTest(LOGICAL,96)@9 + 1
    excRNaN_uid97_fpSubTest_qi <= excAIBISub_uid96_fpSubTest_q or excRNaN2_uid95_fpSubTest_q;
    excRNaN_uid97_fpSubTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => excRNaN_uid97_fpSubTest_qi, xout => excRNaN_uid97_fpSubTest_q, clk => clk, aclr => areset );

    -- invExcRNaN_uid109_fpSubTest(LOGICAL,108)@10
    invExcRNaN_uid109_fpSubTest_q <= not (excRNaN_uid97_fpSubTest_q);

    -- VCC(CONSTANT,1)
    VCC_q <= "1";

    -- signRPostExc_uid110_fpSubTest(LOGICAL,109)@10
    signRPostExc_uid110_fpSubTest_q <= invExcRNaN_uid109_fpSubTest_q and signRInfRZRReg_uid108_fpSubTest_q;

    -- expInc_uid79_fpSubTest(ADD,78)@7 + 1
    expInc_uid79_fpSubTest_a <= STD_LOGIC_VECTOR("0" & redist25_exp_aSig_uid22_fpSubTest_b_5_q);
    expInc_uid79_fpSubTest_b <= STD_LOGIC_VECTOR("00000" & VCC_q);
    expInc_uid79_fpSubTest_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            expInc_uid79_fpSubTest_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            expInc_uid79_fpSubTest_o <= STD_LOGIC_VECTOR(UNSIGNED(expInc_uid79_fpSubTest_a) + UNSIGNED(expInc_uid79_fpSubTest_b));
        END IF;
    END PROCESS;
    expInc_uid79_fpSubTest_q <= expInc_uid79_fpSubTest_o(5 downto 0);

    -- expPostNorm_uid80_fpSubTest(SUB,79)@8 + 1
    expPostNorm_uid80_fpSubTest_a <= STD_LOGIC_VECTOR("0" & expInc_uid79_fpSubTest_q);
    expPostNorm_uid80_fpSubTest_b <= STD_LOGIC_VECTOR("000" & r_uid144_lzCountVal_uid75_fpSubTest_q);
    expPostNorm_uid80_fpSubTest_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            expPostNorm_uid80_fpSubTest_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            expPostNorm_uid80_fpSubTest_o <= STD_LOGIC_VECTOR(UNSIGNED(expPostNorm_uid80_fpSubTest_a) - UNSIGNED(expPostNorm_uid80_fpSubTest_b));
        END IF;
    END PROCESS;
    expPostNorm_uid80_fpSubTest_q <= expPostNorm_uid80_fpSubTest_o(6 downto 0);

    -- leftShiftStage1Idx3Rng3_uid195_fracPostNorm_uid76_fpSubTest(BITSELECT,194)@8
    leftShiftStage1Idx3Rng3_uid195_fracPostNorm_uid76_fpSubTest_in <= leftShiftStage0_uid187_fracPostNorm_uid76_fpSubTest_q(10 downto 0);
    leftShiftStage1Idx3Rng3_uid195_fracPostNorm_uid76_fpSubTest_b <= leftShiftStage1Idx3Rng3_uid195_fracPostNorm_uid76_fpSubTest_in(10 downto 0);

    -- leftShiftStage1Idx3Pad3_uid194_fracPostNorm_uid76_fpSubTest(CONSTANT,193)
    leftShiftStage1Idx3Pad3_uid194_fracPostNorm_uid76_fpSubTest_q <= "000";

    -- leftShiftStage1Idx3_uid196_fracPostNorm_uid76_fpSubTest(BITJOIN,195)@8
    leftShiftStage1Idx3_uid196_fracPostNorm_uid76_fpSubTest_q <= leftShiftStage1Idx3Rng3_uid195_fracPostNorm_uid76_fpSubTest_b & leftShiftStage1Idx3Pad3_uid194_fracPostNorm_uid76_fpSubTest_q;

    -- leftShiftStage1Idx2Rng2_uid192_fracPostNorm_uid76_fpSubTest(BITSELECT,191)@8
    leftShiftStage1Idx2Rng2_uid192_fracPostNorm_uid76_fpSubTest_in <= leftShiftStage0_uid187_fracPostNorm_uid76_fpSubTest_q(11 downto 0);
    leftShiftStage1Idx2Rng2_uid192_fracPostNorm_uid76_fpSubTest_b <= leftShiftStage1Idx2Rng2_uid192_fracPostNorm_uid76_fpSubTest_in(11 downto 0);

    -- leftShiftStage1Idx2_uid193_fracPostNorm_uid76_fpSubTest(BITJOIN,192)@8
    leftShiftStage1Idx2_uid193_fracPostNorm_uid76_fpSubTest_q <= leftShiftStage1Idx2Rng2_uid192_fracPostNorm_uid76_fpSubTest_b & zs_uid135_lzCountVal_uid75_fpSubTest_q;

    -- leftShiftStage1Idx1Rng1_uid189_fracPostNorm_uid76_fpSubTest(BITSELECT,188)@8
    leftShiftStage1Idx1Rng1_uid189_fracPostNorm_uid76_fpSubTest_in <= leftShiftStage0_uid187_fracPostNorm_uid76_fpSubTest_q(12 downto 0);
    leftShiftStage1Idx1Rng1_uid189_fracPostNorm_uid76_fpSubTest_b <= leftShiftStage1Idx1Rng1_uid189_fracPostNorm_uid76_fpSubTest_in(12 downto 0);

    -- leftShiftStage1Idx1_uid190_fracPostNorm_uid76_fpSubTest(BITJOIN,189)@8
    leftShiftStage1Idx1_uid190_fracPostNorm_uid76_fpSubTest_q <= leftShiftStage1Idx1Rng1_uid189_fracPostNorm_uid76_fpSubTest_b & GND_q;

    -- leftShiftStage0Idx3Rng12_uid184_fracPostNorm_uid76_fpSubTest(BITSELECT,183)@8
    leftShiftStage0Idx3Rng12_uid184_fracPostNorm_uid76_fpSubTest_in <= redist10_fracAddResultNoSignExt_uid74_fpSubTest_b_3_q(1 downto 0);
    leftShiftStage0Idx3Rng12_uid184_fracPostNorm_uid76_fpSubTest_b <= leftShiftStage0Idx3Rng12_uid184_fracPostNorm_uid76_fpSubTest_in(1 downto 0);

    -- leftShiftStage0Idx3Pad12_uid183_fracPostNorm_uid76_fpSubTest(CONSTANT,182)
    leftShiftStage0Idx3Pad12_uid183_fracPostNorm_uid76_fpSubTest_q <= "000000000000";

    -- leftShiftStage0Idx3_uid185_fracPostNorm_uid76_fpSubTest(BITJOIN,184)@8
    leftShiftStage0Idx3_uid185_fracPostNorm_uid76_fpSubTest_q <= leftShiftStage0Idx3Rng12_uid184_fracPostNorm_uid76_fpSubTest_b & leftShiftStage0Idx3Pad12_uid183_fracPostNorm_uid76_fpSubTest_q;

    -- redist3_vStage_uid125_lzCountVal_uid75_fpSubTest_b_2(DELAY,206)
    redist3_vStage_uid125_lzCountVal_uid75_fpSubTest_b_2 : dspba_delay
    GENERIC MAP ( width => 6, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => vStage_uid125_lzCountVal_uid75_fpSubTest_b, xout => redist3_vStage_uid125_lzCountVal_uid75_fpSubTest_b_2_q, clk => clk, aclr => areset );

    -- leftShiftStage0Idx2_uid182_fracPostNorm_uid76_fpSubTest(BITJOIN,181)@8
    leftShiftStage0Idx2_uid182_fracPostNorm_uid76_fpSubTest_q <= redist3_vStage_uid125_lzCountVal_uid75_fpSubTest_b_2_q & zs_uid121_lzCountVal_uid75_fpSubTest_q;

    -- leftShiftStage0Idx1Rng4_uid178_fracPostNorm_uid76_fpSubTest(BITSELECT,177)@8
    leftShiftStage0Idx1Rng4_uid178_fracPostNorm_uid76_fpSubTest_in <= redist10_fracAddResultNoSignExt_uid74_fpSubTest_b_3_q(9 downto 0);
    leftShiftStage0Idx1Rng4_uid178_fracPostNorm_uid76_fpSubTest_b <= leftShiftStage0Idx1Rng4_uid178_fracPostNorm_uid76_fpSubTest_in(9 downto 0);

    -- leftShiftStage0Idx1_uid179_fracPostNorm_uid76_fpSubTest(BITJOIN,178)@8
    leftShiftStage0Idx1_uid179_fracPostNorm_uid76_fpSubTest_q <= leftShiftStage0Idx1Rng4_uid178_fracPostNorm_uid76_fpSubTest_b & zs_uid129_lzCountVal_uid75_fpSubTest_q;

    -- redist10_fracAddResultNoSignExt_uid74_fpSubTest_b_3(DELAY,213)
    redist10_fracAddResultNoSignExt_uid74_fpSubTest_b_3 : dspba_delay
    GENERIC MAP ( width => 14, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => redist9_fracAddResultNoSignExt_uid74_fpSubTest_b_1_q, xout => redist10_fracAddResultNoSignExt_uid74_fpSubTest_b_3_q, clk => clk, aclr => areset );

    -- leftShiftStage0_uid187_fracPostNorm_uid76_fpSubTest(MUX,186)@8
    leftShiftStage0_uid187_fracPostNorm_uid76_fpSubTest_s <= leftShiftStageSel3Dto2_uid186_fracPostNorm_uid76_fpSubTest_merged_bit_select_b;
    leftShiftStage0_uid187_fracPostNorm_uid76_fpSubTest_combproc: PROCESS (leftShiftStage0_uid187_fracPostNorm_uid76_fpSubTest_s, redist10_fracAddResultNoSignExt_uid74_fpSubTest_b_3_q, leftShiftStage0Idx1_uid179_fracPostNorm_uid76_fpSubTest_q, leftShiftStage0Idx2_uid182_fracPostNorm_uid76_fpSubTest_q, leftShiftStage0Idx3_uid185_fracPostNorm_uid76_fpSubTest_q)
    BEGIN
        CASE (leftShiftStage0_uid187_fracPostNorm_uid76_fpSubTest_s) IS
            WHEN "00" => leftShiftStage0_uid187_fracPostNorm_uid76_fpSubTest_q <= redist10_fracAddResultNoSignExt_uid74_fpSubTest_b_3_q;
            WHEN "01" => leftShiftStage0_uid187_fracPostNorm_uid76_fpSubTest_q <= leftShiftStage0Idx1_uid179_fracPostNorm_uid76_fpSubTest_q;
            WHEN "10" => leftShiftStage0_uid187_fracPostNorm_uid76_fpSubTest_q <= leftShiftStage0Idx2_uid182_fracPostNorm_uid76_fpSubTest_q;
            WHEN "11" => leftShiftStage0_uid187_fracPostNorm_uid76_fpSubTest_q <= leftShiftStage0Idx3_uid185_fracPostNorm_uid76_fpSubTest_q;
            WHEN OTHERS => leftShiftStage0_uid187_fracPostNorm_uid76_fpSubTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- leftShiftStageSel3Dto2_uid186_fracPostNorm_uid76_fpSubTest_merged_bit_select(BITSELECT,202)@8
    leftShiftStageSel3Dto2_uid186_fracPostNorm_uid76_fpSubTest_merged_bit_select_b <= r_uid144_lzCountVal_uid75_fpSubTest_q(3 downto 2);
    leftShiftStageSel3Dto2_uid186_fracPostNorm_uid76_fpSubTest_merged_bit_select_c <= r_uid144_lzCountVal_uid75_fpSubTest_q(1 downto 0);

    -- leftShiftStage1_uid198_fracPostNorm_uid76_fpSubTest(MUX,197)@8
    leftShiftStage1_uid198_fracPostNorm_uid76_fpSubTest_s <= leftShiftStageSel3Dto2_uid186_fracPostNorm_uid76_fpSubTest_merged_bit_select_c;
    leftShiftStage1_uid198_fracPostNorm_uid76_fpSubTest_combproc: PROCESS (leftShiftStage1_uid198_fracPostNorm_uid76_fpSubTest_s, leftShiftStage0_uid187_fracPostNorm_uid76_fpSubTest_q, leftShiftStage1Idx1_uid190_fracPostNorm_uid76_fpSubTest_q, leftShiftStage1Idx2_uid193_fracPostNorm_uid76_fpSubTest_q, leftShiftStage1Idx3_uid196_fracPostNorm_uid76_fpSubTest_q)
    BEGIN
        CASE (leftShiftStage1_uid198_fracPostNorm_uid76_fpSubTest_s) IS
            WHEN "00" => leftShiftStage1_uid198_fracPostNorm_uid76_fpSubTest_q <= leftShiftStage0_uid187_fracPostNorm_uid76_fpSubTest_q;
            WHEN "01" => leftShiftStage1_uid198_fracPostNorm_uid76_fpSubTest_q <= leftShiftStage1Idx1_uid190_fracPostNorm_uid76_fpSubTest_q;
            WHEN "10" => leftShiftStage1_uid198_fracPostNorm_uid76_fpSubTest_q <= leftShiftStage1Idx2_uid193_fracPostNorm_uid76_fpSubTest_q;
            WHEN "11" => leftShiftStage1_uid198_fracPostNorm_uid76_fpSubTest_q <= leftShiftStage1Idx3_uid196_fracPostNorm_uid76_fpSubTest_q;
            WHEN OTHERS => leftShiftStage1_uid198_fracPostNorm_uid76_fpSubTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- fracPostNormRndRange_uid81_fpSubTest(BITSELECT,80)@8
    fracPostNormRndRange_uid81_fpSubTest_in <= leftShiftStage1_uid198_fracPostNorm_uid76_fpSubTest_q(12 downto 0);
    fracPostNormRndRange_uid81_fpSubTest_b <= fracPostNormRndRange_uid81_fpSubTest_in(12 downto 2);

    -- redist8_fracPostNormRndRange_uid81_fpSubTest_b_1(DELAY,211)
    redist8_fracPostNormRndRange_uid81_fpSubTest_b_1 : dspba_delay
    GENERIC MAP ( width => 11, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracPostNormRndRange_uid81_fpSubTest_b, xout => redist8_fracPostNormRndRange_uid81_fpSubTest_b_1_q, clk => clk, aclr => areset );

    -- expFracR_uid82_fpSubTest(BITJOIN,81)@9
    expFracR_uid82_fpSubTest_q <= expPostNorm_uid80_fpSubTest_q & redist8_fracPostNormRndRange_uid81_fpSubTest_b_1_q;

    -- expRPreExc_uid88_fpSubTest(BITSELECT,87)@9
    expRPreExc_uid88_fpSubTest_in <= expFracR_uid82_fpSubTest_q(15 downto 0);
    expRPreExc_uid88_fpSubTest_b <= expRPreExc_uid88_fpSubTest_in(15 downto 11);

    -- redist6_expRPreExc_uid88_fpSubTest_b_1(DELAY,209)
    redist6_expRPreExc_uid88_fpSubTest_b_1 : dspba_delay
    GENERIC MAP ( width => 5, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => expRPreExc_uid88_fpSubTest_b, xout => redist6_expRPreExc_uid88_fpSubTest_b_1_q, clk => clk, aclr => areset );

    -- wEP2AllOwE_uid83_fpSubTest(CONSTANT,82)
    wEP2AllOwE_uid83_fpSubTest_q <= "0011111";

    -- rndExp_uid84_fpSubTest(BITSELECT,83)@9
    rndExp_uid84_fpSubTest_b <= expFracR_uid82_fpSubTest_q(17 downto 11);

    -- rOvf_uid85_fpSubTest(LOGICAL,84)@9
    rOvf_uid85_fpSubTest_q <= "1" WHEN rndExp_uid84_fpSubTest_b = wEP2AllOwE_uid83_fpSubTest_q ELSE "0";

    -- regInputs_uid89_fpSubTest(LOGICAL,88)@9
    regInputs_uid89_fpSubTest_q <= excR_aSig_uid32_fpSubTest_q and excR_bSig_uid46_fpSubTest_q;

    -- rInfOvf_uid92_fpSubTest(LOGICAL,91)@9
    rInfOvf_uid92_fpSubTest_q <= regInputs_uid89_fpSubTest_q and rOvf_uid85_fpSubTest_q;

    -- excRInfVInC_uid93_fpSubTest(BITJOIN,92)@9
    excRInfVInC_uid93_fpSubTest_q <= rInfOvf_uid92_fpSubTest_q & excN_bSig_uid43_fpSubTest_q & excN_aSig_uid29_fpSubTest_q & excI_bSig_uid42_fpSubTest_q & excI_aSig_uid28_fpSubTest_q & redist13_effSub_uid53_fpSubTest_q_7_q;

    -- redist5_excRInfVInC_uid93_fpSubTest_q_1(DELAY,208)
    redist5_excRInfVInC_uid93_fpSubTest_q_1 : dspba_delay
    GENERIC MAP ( width => 6, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => excRInfVInC_uid93_fpSubTest_q, xout => redist5_excRInfVInC_uid93_fpSubTest_q_1_q, clk => clk, aclr => areset );

    -- excRInf_uid94_fpSubTest(LOOKUP,93)@10
    excRInf_uid94_fpSubTest_combproc: PROCESS (redist5_excRInfVInC_uid93_fpSubTest_q_1_q)
    BEGIN
        -- Begin reserved scope level
        CASE (redist5_excRInfVInC_uid93_fpSubTest_q_1_q) IS
            WHEN "000000" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "000001" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "000010" => excRInf_uid94_fpSubTest_q <= "1";
            WHEN "000011" => excRInf_uid94_fpSubTest_q <= "1";
            WHEN "000100" => excRInf_uid94_fpSubTest_q <= "1";
            WHEN "000101" => excRInf_uid94_fpSubTest_q <= "1";
            WHEN "000110" => excRInf_uid94_fpSubTest_q <= "1";
            WHEN "000111" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "001000" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "001001" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "001010" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "001011" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "001100" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "001101" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "001110" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "001111" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "010000" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "010001" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "010010" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "010011" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "010100" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "010101" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "010110" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "010111" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "011000" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "011001" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "011010" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "011011" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "011100" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "011101" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "011110" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "011111" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "100000" => excRInf_uid94_fpSubTest_q <= "1";
            WHEN "100001" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "100010" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "100011" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "100100" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "100101" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "100110" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "100111" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "101000" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "101001" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "101010" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "101011" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "101100" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "101101" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "101110" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "101111" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "110000" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "110001" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "110010" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "110011" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "110100" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "110101" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "110110" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "110111" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "111000" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "111001" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "111010" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "111011" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "111100" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "111101" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "111110" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN "111111" => excRInf_uid94_fpSubTest_q <= "0";
            WHEN OTHERS => -- unreachable
                           excRInf_uid94_fpSubTest_q <= (others => '-');
        END CASE;
        -- End reserved scope level
    END PROCESS;

    -- rUdf_uid86_fpSubTest(BITSELECT,85)@9
    rUdf_uid86_fpSubTest_b <= STD_LOGIC_VECTOR(expFracR_uid82_fpSubTest_q(17 downto 17));

    -- excRZeroVInC_uid90_fpSubTest(BITJOIN,89)@9
    excRZeroVInC_uid90_fpSubTest_q <= aMinusA_uid78_fpSubTest_q & rUdf_uid86_fpSubTest_b & regInputs_uid89_fpSubTest_q & redist19_excZ_bSig_uid18_uid38_fpSubTest_q_7_q & redist22_excZ_aSig_uid17_uid24_fpSubTest_q_2_q;

    -- excRZero_uid91_fpSubTest(LOOKUP,90)@9 + 1
    excRZero_uid91_fpSubTest_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            excRZero_uid91_fpSubTest_q <= "0";
        ELSIF (clk'EVENT AND clk = '1') THEN
            CASE (excRZeroVInC_uid90_fpSubTest_q) IS
                WHEN "00000" => excRZero_uid91_fpSubTest_q <= "0";
                WHEN "00001" => excRZero_uid91_fpSubTest_q <= "0";
                WHEN "00010" => excRZero_uid91_fpSubTest_q <= "0";
                WHEN "00011" => excRZero_uid91_fpSubTest_q <= "1";
                WHEN "00100" => excRZero_uid91_fpSubTest_q <= "0";
                WHEN "00101" => excRZero_uid91_fpSubTest_q <= "0";
                WHEN "00110" => excRZero_uid91_fpSubTest_q <= "0";
                WHEN "00111" => excRZero_uid91_fpSubTest_q <= "0";
                WHEN "01000" => excRZero_uid91_fpSubTest_q <= "0";
                WHEN "01001" => excRZero_uid91_fpSubTest_q <= "0";
                WHEN "01010" => excRZero_uid91_fpSubTest_q <= "0";
                WHEN "01011" => excRZero_uid91_fpSubTest_q <= "1";
                WHEN "01100" => excRZero_uid91_fpSubTest_q <= "1";
                WHEN "01101" => excRZero_uid91_fpSubTest_q <= "0";
                WHEN "01110" => excRZero_uid91_fpSubTest_q <= "0";
                WHEN "01111" => excRZero_uid91_fpSubTest_q <= "0";
                WHEN "10000" => excRZero_uid91_fpSubTest_q <= "0";
                WHEN "10001" => excRZero_uid91_fpSubTest_q <= "0";
                WHEN "10010" => excRZero_uid91_fpSubTest_q <= "0";
                WHEN "10011" => excRZero_uid91_fpSubTest_q <= "1";
                WHEN "10100" => excRZero_uid91_fpSubTest_q <= "1";
                WHEN "10101" => excRZero_uid91_fpSubTest_q <= "0";
                WHEN "10110" => excRZero_uid91_fpSubTest_q <= "0";
                WHEN "10111" => excRZero_uid91_fpSubTest_q <= "0";
                WHEN "11000" => excRZero_uid91_fpSubTest_q <= "0";
                WHEN "11001" => excRZero_uid91_fpSubTest_q <= "0";
                WHEN "11010" => excRZero_uid91_fpSubTest_q <= "0";
                WHEN "11011" => excRZero_uid91_fpSubTest_q <= "1";
                WHEN "11100" => excRZero_uid91_fpSubTest_q <= "1";
                WHEN "11101" => excRZero_uid91_fpSubTest_q <= "0";
                WHEN "11110" => excRZero_uid91_fpSubTest_q <= "0";
                WHEN "11111" => excRZero_uid91_fpSubTest_q <= "0";
                WHEN OTHERS => -- unreachable
                               excRZero_uid91_fpSubTest_q <= (others => '-');
            END CASE;
        END IF;
    END PROCESS;

    -- concExc_uid98_fpSubTest(BITJOIN,97)@10
    concExc_uid98_fpSubTest_q <= excRNaN_uid97_fpSubTest_q & excRInf_uid94_fpSubTest_q & excRZero_uid91_fpSubTest_q;

    -- excREnc_uid99_fpSubTest(LOOKUP,98)@10
    excREnc_uid99_fpSubTest_combproc: PROCESS (concExc_uid98_fpSubTest_q)
    BEGIN
        -- Begin reserved scope level
        CASE (concExc_uid98_fpSubTest_q) IS
            WHEN "000" => excREnc_uid99_fpSubTest_q <= "01";
            WHEN "001" => excREnc_uid99_fpSubTest_q <= "00";
            WHEN "010" => excREnc_uid99_fpSubTest_q <= "10";
            WHEN "011" => excREnc_uid99_fpSubTest_q <= "10";
            WHEN "100" => excREnc_uid99_fpSubTest_q <= "11";
            WHEN "101" => excREnc_uid99_fpSubTest_q <= "11";
            WHEN "110" => excREnc_uid99_fpSubTest_q <= "11";
            WHEN "111" => excREnc_uid99_fpSubTest_q <= "11";
            WHEN OTHERS => -- unreachable
                           excREnc_uid99_fpSubTest_q <= (others => '-');
        END CASE;
        -- End reserved scope level
    END PROCESS;

    -- expRPostExc_uid118_fpSubTest(MUX,117)@10
    expRPostExc_uid118_fpSubTest_s <= excREnc_uid99_fpSubTest_q;
    expRPostExc_uid118_fpSubTest_combproc: PROCESS (expRPostExc_uid118_fpSubTest_s, cstAllZWE_uid21_fpSubTest_q, redist6_expRPreExc_uid88_fpSubTest_b_1_q, cstAllOWE_uid19_fpSubTest_q)
    BEGIN
        CASE (expRPostExc_uid118_fpSubTest_s) IS
            WHEN "00" => expRPostExc_uid118_fpSubTest_q <= cstAllZWE_uid21_fpSubTest_q;
            WHEN "01" => expRPostExc_uid118_fpSubTest_q <= redist6_expRPreExc_uid88_fpSubTest_b_1_q;
            WHEN "10" => expRPostExc_uid118_fpSubTest_q <= cstAllOWE_uid19_fpSubTest_q;
            WHEN "11" => expRPostExc_uid118_fpSubTest_q <= cstAllOWE_uid19_fpSubTest_q;
            WHEN OTHERS => expRPostExc_uid118_fpSubTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- oneFracRPostExc2_uid111_fpSubTest(CONSTANT,110)
    oneFracRPostExc2_uid111_fpSubTest_q <= "0000000001";

    -- fracRPreExc_uid87_fpSubTest(BITSELECT,86)@9
    fracRPreExc_uid87_fpSubTest_in <= expFracR_uid82_fpSubTest_q(10 downto 0);
    fracRPreExc_uid87_fpSubTest_b <= fracRPreExc_uid87_fpSubTest_in(10 downto 1);

    -- redist7_fracRPreExc_uid87_fpSubTest_b_1(DELAY,210)
    redist7_fracRPreExc_uid87_fpSubTest_b_1 : dspba_delay
    GENERIC MAP ( width => 10, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracRPreExc_uid87_fpSubTest_b, xout => redist7_fracRPreExc_uid87_fpSubTest_b_1_q, clk => clk, aclr => areset );

    -- fracRPostExc_uid114_fpSubTest(MUX,113)@10
    fracRPostExc_uid114_fpSubTest_s <= excREnc_uid99_fpSubTest_q;
    fracRPostExc_uid114_fpSubTest_combproc: PROCESS (fracRPostExc_uid114_fpSubTest_s, cstZeroWF_uid20_fpSubTest_q, redist7_fracRPreExc_uid87_fpSubTest_b_1_q, oneFracRPostExc2_uid111_fpSubTest_q)
    BEGIN
        CASE (fracRPostExc_uid114_fpSubTest_s) IS
            WHEN "00" => fracRPostExc_uid114_fpSubTest_q <= cstZeroWF_uid20_fpSubTest_q;
            WHEN "01" => fracRPostExc_uid114_fpSubTest_q <= redist7_fracRPreExc_uid87_fpSubTest_b_1_q;
            WHEN "10" => fracRPostExc_uid114_fpSubTest_q <= cstZeroWF_uid20_fpSubTest_q;
            WHEN "11" => fracRPostExc_uid114_fpSubTest_q <= oneFracRPostExc2_uid111_fpSubTest_q;
            WHEN OTHERS => fracRPostExc_uid114_fpSubTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- R_uid119_fpSubTest(BITJOIN,118)@10
    R_uid119_fpSubTest_q <= signRPostExc_uid110_fpSubTest_q & expRPostExc_uid118_fpSubTest_q & fracRPostExc_uid114_fpSubTest_q;

    -- xOut(GPOUT,4)@10
    q <= R_uid119_fpSubTest_q;

END normal;
